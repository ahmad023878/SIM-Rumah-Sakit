<?php
/** Shared Mamdani engine; membership functions and 729-rule inference match M4. */
if (!function_exists('hms_fuzzy_clamp')) {
    function hms_fuzzy_clamp($v, $min, $max) { return max($min, min($max, (float)$v)); }
}
if (!function_exists('hms_fuzzy_tri')) {
    function hms_fuzzy_tri($x, $a, $b, $c) {
        if ($x < $a || $x > $c) return 0.0;
        if ($x == $b) return 1.0;
        if ($x < $b) return ($b == $a) ? 1.0 : max(0.0, ($x - $a) / ($b - $a));
        return ($c == $b) ? 1.0 : max(0.0, ($c - $x) / ($c - $b));
    }
}
if (!function_exists('hms_fuzzy_trap')) {
    function hms_fuzzy_trap($x, $a, $b, $c, $d) {
        if ($x < $a || $x > $d) return 0.0;
        if ($x >= $b && $x <= $c) return 1.0;
        if ($x < $b) return ($b == $a) ? 1.0 : max(0.0, ($x - $a) / ($b - $a));
        return ($d == $c) ? 1.0 : max(0.0, ($d - $x) / ($d - $c));
    }
}
if (!function_exists('hms_fuzzy_sets')) {
    function hms_fuzzy_sets($key, $x) {
        // Himpunan disusun dalam tingkat tekanan operasional: rendah, sedang, tinggi.
        switch ($key) {
            case 'duration': return array('rendah'=>hms_fuzzy_trap($x,0,0,15,35),'sedang'=>hms_fuzzy_tri($x,20,45,75),'tinggi'=>hms_fuzzy_trap($x,60,90,120,120));
            case 'queue': return array('rendah'=>hms_fuzzy_trap($x,0,0,4,10),'sedang'=>hms_fuzzy_tri($x,7,15,25),'tinggi'=>hms_fuzzy_trap($x,20,30,40,40));
            case 'utilization': return array('rendah'=>hms_fuzzy_trap($x,0,0,30,50),'sedang'=>hms_fuzzy_tri($x,35,55,75),'tinggi'=>hms_fuzzy_trap($x,65,85,100,100));
            case 'occupancy': return array('rendah'=>hms_fuzzy_trap($x,0,0,30,50),'sedang'=>hms_fuzzy_tri($x,35,55,75),'tinggi'=>hms_fuzzy_trap($x,65,85,100,100));
            // Availability dibalik: ketersediaan rendah berarti tekanan operasional tinggi.
            case 'availability': return array('rendah'=>hms_fuzzy_trap($x,60,80,100,100),'sedang'=>hms_fuzzy_tri($x,30,50,70),'tinggi'=>hms_fuzzy_trap($x,0,0,20,40));
            case 'delay': return array('rendah'=>hms_fuzzy_trap($x,0,0,20,50),'sedang'=>hms_fuzzy_tri($x,30,75,130),'tinggi'=>hms_fuzzy_trap($x,100,160,240,240));
        }
        return array('rendah'=>0.0,'sedang'=>0.0,'tinggi'=>0.0);
    }
}
if (!function_exists('hms_fuzzy_output_mu')) {
    function hms_fuzzy_output_mu($x, $set) {
        if ($set === 'rendah') return hms_fuzzy_trap($x,0,0,20,40);
        if ($set === 'sedang') return hms_fuzzy_tri($x,25,50,75);
        return hms_fuzzy_trap($x,60,80,100,100);
    }
}
if (!function_exists('hms_fuzzy_infer')) {
    function hms_fuzzy_infer($inputs) {
        $keys = array('duration','queue','utilization','occupancy','availability','delay');
        $sets = array();
        foreach ($keys as $key) $sets[$key] = hms_fuzzy_sets($key, $inputs[$key]);
        $names = array('rendah','sedang','tinggi');
        $severity = array('rendah'=>0,'sedang'=>1,'tinggi'=>2);
        $aggregated = array_fill(0,101,0.0);
        $active = 0;
        // Full 3^6 rule base (729 combinations). Consequent follows average pressure level.
        foreach ($names as $a) foreach ($names as $b) foreach ($names as $c)
        foreach ($names as $d) foreach ($names as $e) foreach ($names as $f) {
            $combo = array($a,$b,$c,$d,$e,$f);
            $alpha = min($sets['duration'][$a],$sets['queue'][$b],$sets['utilization'][$c],$sets['occupancy'][$d],$sets['availability'][$e],$sets['delay'][$f]);
            if ($alpha <= 0) continue;
            $active++;
            $avg = ($severity[$a]+$severity[$b]+$severity[$c]+$severity[$d]+$severity[$e]+$severity[$f])/6;
            $out = ($avg <= 0.65) ? 'rendah' : (($avg <= 1.35) ? 'sedang' : 'tinggi');
            for ($x=0;$x<=100;$x++) $aggregated[$x] = max($aggregated[$x], min($alpha,hms_fuzzy_output_mu($x,$out)));
        }
        $num=0.0; $den=0.0;
        foreach ($aggregated as $x=>$mu) { $num += $x*$mu; $den += $mu; }
        $crisp = $den > 0 ? $num/$den : 0.0;
        $category = $crisp < 40 ? 'Rendah' : ($crisp < 65 ? 'Sedang' : 'Tinggi');
        return array('degrees'=>$sets,'aggregated'=>$aggregated,'crisp'=>$crisp,'category'=>$category,'active_rules'=>$active);
    }
}


