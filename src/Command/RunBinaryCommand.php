<?php

declare(strict_types=1);

namespace Voyager\QualityTools\Command;

use Composer\Command\BaseCommand;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;
use Voyager\QualityTools\ToolkitPaths;

final class RunBinaryCommand extends BaseCommand
{
    /**
     * @param list<string> $arguments
     */
    public function __construct(private readonly string $commandName, private readonly string $binary, private readonly array $arguments, string $description)
    {
        parent::__construct($commandName);

        $this->setDescription($description);
    }

    protected function execute(InputInterface $input, OutputInterface $output): int
    {
        $binaryPath = ToolkitPaths::resolveProjectPath() . '/vendor/bin/' . $this->binary;

        if (!is_file($binaryPath) && !is_link($binaryPath)) {
            $output->writeln(sprintf('<error>Unable to locate binary "%s". Did you run composer install?</error>', $binaryPath));

            return BaseCommand::FAILURE;
        }

        $command = array_merge([$binaryPath], $this->arguments);
        $descriptorSpec = [
            0 => STDIN,
            1 => STDOUT,
            2 => STDERR,
        ];

        $process = proc_open($command, $descriptorSpec, $pipes, ToolkitPaths::resolveProjectPath());

        if (!is_resource($process)) {
            $output->writeln('<error>Failed to start process.</error>');

            return BaseCommand::FAILURE;
        }

        $status = proc_close($process);

        return $status === 0 ? BaseCommand::SUCCESS : BaseCommand::FAILURE;
    }
}
