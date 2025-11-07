<?php

declare(strict_types=1);

namespace Voyager\QualityTools\Command;

use Composer\Command\BaseCommand;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;
use Voyager\QualityTools\ToolkitPaths;

final class RunScriptCommand extends BaseCommand
{
    public function __construct(private readonly string $commandName, private readonly string $scriptName, string $description)
    {
        parent::__construct($commandName);

        $this->setDescription($description);
    }

    protected function execute(InputInterface $input, OutputInterface $output): int
    {
        $scriptPath = ToolkitPaths::resolveToolkitPath() . '/scripts/' . $this->scriptName;

        if (!is_file($scriptPath)) {
            $output->writeln(sprintf('<error>Unable to locate script "%s".</error>', $scriptPath));

            return BaseCommand::FAILURE;
        }

        $command = ['bash', $scriptPath];
        $descriptorSpec = [
            0 => STDIN,
            1 => STDOUT,
            2 => STDERR,
        ];

        $process = proc_open($command, $descriptorSpec, $pipes, ToolkitPaths::resolveProjectPath());

        if (!is_resource($process)) {
            $output->writeln('<error>Failed to start script process.</error>');

            return BaseCommand::FAILURE;
        }

        $status = proc_close($process);

        return $status === 0 ? BaseCommand::SUCCESS : BaseCommand::FAILURE;
    }
}
