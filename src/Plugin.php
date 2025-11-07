<?php

declare(strict_types=1);

namespace Voyager\QualityTools;

use Composer\Plugin\Capable;
use Composer\Plugin\PluginInterface;

final class Plugin implements PluginInterface, Capable
{
    public function activate(\Composer\Composer $composer, \Composer\IO\IOInterface $io): void
    {
        // No-op
    }

    public function deactivate(\Composer\Composer $composer, \Composer\IO\IOInterface $io): void
    {
        // No-op
    }

    public function uninstall(\Composer\Composer $composer, \Composer\IO\IOInterface $io): void
    {
        // No-op
    }

    public function getCapabilities(): array
    {
        return [
            \Composer\Plugin\Capability\CommandProvider::class => Command\QualityCommandProvider::class,
        ];
    }
}
