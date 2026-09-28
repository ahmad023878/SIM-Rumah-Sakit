<?php

namespace Config;

use CodeIgniter\Config\AutoloadConfig;

class Autoload extends AutoloadConfig
{
    public $psr4 = [
        'App' => APPPATH,
        'Config' => APPPATH . 'Config',
    ];
    public $classmap = [];

    /**
     * Helpers loaded automatically by CodeIgniter.
     * CodeIgniter 4.7.4's Autoloader reads this property.
     * Keep the original application free to load helpers explicitly.
     *
     * @var list<string>
     */
    public $helpers = [];
}
