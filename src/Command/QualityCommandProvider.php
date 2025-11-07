<?php

declare(strict_types=1);

namespace Voyager\QualityTools\Command;

use Composer\Plugin\Capability\CommandProvider;

final class QualityCommandProvider implements CommandProvider
{
    public function getCommands(): array
    {
        return [
            new RunScriptCommand('quality:phpcs', 'run-phpcs.sh', 'Run PHP_CodeSniffer with the toolkit configuration.'),
            new RunScriptCommand('quality:phpstan', 'run-phpstan.sh', 'Run PHPStan with the toolkit configuration.'),
            new RunBinaryCommand('quality:grumphp', 'grumphp', ['run'], 'Run GrumPHP using project configuration.'),
            new RunScriptCommand('quality:detect-secrets', 'run-detect-secrets.sh', 'Run detect-secrets scanning with optional baseline.'),
            new RunScriptCommand('quality:run', 'run-quality-checks.sh', 'Run the full Voyager quality toolchain.'),
        ];
    }
}
