<?php

declare(strict_types=1);

namespace Voyager\QualityTools;

use Composer\Composer;
use Composer\IO\IOInterface;
use Composer\Package\RootPackageInterface;
use Composer\Plugin\Capable;
use Composer\Plugin\PluginInterface;

final class Plugin implements PluginInterface, Capable
{
    public function activate(Composer $composer, IOInterface $io): void
    {
        $package = $composer->getPackage();

        if (!$package instanceof RootPackageInterface) {
            return;
        }

        $scripts = $package->getScripts();

        $toolkitScripts = [
            'quality:phpcs' => [
                "bash -c 'BASE=vendor/voyager/php-quality-tools; if [ ! -d \"$BASE/scripts\" ]; then BASE=.; fi; bash \"$BASE/scripts/run-phpcs.sh\"'",
            ],
            'quality:phpstan' => [
                "bash -c 'BASE=vendor/voyager/php-quality-tools; if [ ! -d \"$BASE/scripts\" ]; then BASE=.; fi; bash \"$BASE/scripts/run-phpstan.sh\"'",
            ],
            'quality:grumphp' => [
                'vendor/bin/grumphp run',
            ],
            'quality:detect-secrets' => [
                "bash -c 'BASE=vendor/voyager/php-quality-tools; if [ ! -d \"$BASE/scripts\" ]; then BASE=.; fi; bash \"$BASE/scripts/run-detect-secrets.sh\"'",
            ],
            'quality:run' => [
                "bash -c 'BASE=vendor/voyager/php-quality-tools; if [ ! -d \"$BASE/scripts\" ]; then BASE=.; fi; bash \"$BASE/scripts/run-quality-checks.sh\"'",
            ],
        ];

        $updated = false;

        foreach ($toolkitScripts as $name => $definition) {
            if (isset($scripts[$name])) {
                continue;
            }

            $scripts[$name] = $definition;
            $updated = true;
        }

        if ($updated) {
            $package->setScripts($scripts);
            $io->write('<info>voyager/php-quality-tools registered the quality:* Composer scripts for this project.</info>');
        }
    }

    public function deactivate(Composer $composer, IOInterface $io): void
    {
        // No-op
    }

    public function uninstall(Composer $composer, IOInterface $io): void
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
