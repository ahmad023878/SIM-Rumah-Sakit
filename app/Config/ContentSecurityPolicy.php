<?php

namespace Config;

use CodeIgniter\Config\BaseConfig;

/**
 * Content Security Policy configuration.
 *
 * CSP is disabled for this migrated application so the original Hospital
 * template/assets can continue to load unchanged. The class is still
 * required by CodeIgniter 4.7.4's CSP service.
 */
class ContentSecurityPolicy extends BaseConfig
{
    public string|array $baseURI = [];
    public string|array $childSrc = [];
    public string|array $connectSrc = [];
    public string|array $defaultSrc = [];
    public string|array $fontSrc = [];
    public string|array $formAction = [];
    public string|array $frameAncestors = [];
    public string|array $frameSrc = [];
    public string|array $imageSrc = [];
    public string|array $mediaSrc = [];
    public string|array $objectSrc = [];
    public string|array $pluginTypes = [];
    public string|array $scriptSrc = [];
    public string|array $styleSrc = [];
    public string|array $sandbox = [];
    public string|array $manifestSrc = [];
    public string|array $scriptSrcElem = [];
    public string|array $scriptSrcAttr = [];
    public string|array $styleSrcElem = [];
    public string|array $styleSrcAttr = [];
    public string|array $workerSrc = [];
    public bool $upgradeInsecureRequests = false;
    public bool $reportOnly = false;
    public string $reportURI = '';
    public string $reportTo = '';
}
