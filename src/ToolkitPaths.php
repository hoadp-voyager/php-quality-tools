<?php

declare(strict_types=1);

namespace Voyager\QualityTools;

final class ToolkitPaths
{
    public static function resolveToolkitPath(): string
    {
        $projectPath = self::resolveProjectPath();
        $vendorPath = $projectPath . '/vendor/voyager/php-quality-tools';

        if (is_dir($vendorPath)) {
            return $vendorPath;
        }

        return dirname(__DIR__);
    }

    public static function resolveProjectPath(): string
    {
        $cwd = getcwd();

        return $cwd !== false ? $cwd : dirname(__DIR__);
    }
}
