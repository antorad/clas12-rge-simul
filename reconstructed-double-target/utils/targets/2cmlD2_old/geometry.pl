use strict;
use warnings;

our %configuration;
our %parameters;

sub build_targets
{
	my $thisVariation = $configuration{"variation"} ;

	
	# cad variation has two volumes:
	# target container
	# and inside cell
	if($thisVariation eq "lD2-full")
	{
		my $nplanes = 4;

		my @oradius  =  (    55,   55,  21.1,  21.1 );
		# NOMINAL : (  -140.0,  265.0, 280.0, 280.0 );
		my @z_plane  =  (  -135.0,  265.0, 280.0, 280.0 );

		# vacuum target container
		my %detector = init_det();
		$detector{"name"}        = "target";
		$detector{"mother"}      = "root";
		$detector{"description"} = "Target Container";
		$detector{"color"}       = "22ff22";
		$detector{"type"}        = "Polycone";
		my $dimen = "0.0*deg 360*deg $nplanes*counts";
		for(my $i = 0; $i <$nplanes; $i++) {$dimen = $dimen ." 0.0*mm";}
		for(my $i = 0; $i <$nplanes; $i++) {$dimen = $dimen ." $oradius[$i]*mm";}
		for(my $i = 0; $i <$nplanes; $i++) {$dimen = $dimen ." $z_plane[$i]*mm";}
		$detector{"dimensions"}  = $dimen;
		$detector{"material"}    = "G4_Galactic";
		$detector{"style"}       = 0;
		print_det(\%configuration, \%detector);


		$nplanes = 5;
		my @oradiusT  =  (   2.5,  8.44,  7.3, 5.0,  2.5);
		my @z_planeT  =  ( -4.2, -1.2, 12.5, 13.5, 14.5);

		# actual target
		%detector = init_det();
		$detector{"name"}        = "lD2";
		$detector{"mother"}      = "target";
		$detector{"description"} = "Target Cell";
		$detector{"color"}       = "aa0000";
		$detector{"type"}        = "Polycone";
		$dimen = "0.0*deg 360*deg $nplanes*counts";
		for(my $i = 0; $i <$nplanes; $i++) {$dimen = $dimen ." 0.0*mm";}
		for(my $i = 0; $i <$nplanes; $i++) {$dimen = $dimen ." $oradiusT[$i]*mm";}
		for(my $i = 0; $i <$nplanes; $i++) {$dimen = $dimen ." $z_planeT[$i]*mm";}
		$detector{"dimensions"}  = $dimen;
		$detector{"material"}    = "LD2"; # defined in gemc database
		$detector{"style"}       = 1;
		print_det(\%configuration, \%detector);

		# reference foil
		my $thickness  = 0.01/2.;
		my $zpos       = 35;
		my $radius     = 7.3;
		$detector{"name"}        = "refFoil";
		$detector{"mother"}      = "target";
		$detector{"description"} = "aluminum refernence foil";
		$detector{"color"}       = "848789";
		$detector{"type"}        = "Tube";
		$detector{"pos"}         = "0 0 $zpos*mm";
		$detector{"dimensions"}  = "0*mm $radius*mm $thickness*mm 0*deg 360*deg";
		$detector{"material"}    = "G4_Al";
		$detector{"sensitivity"} = "flux";
		$detector{"hit_type"}    = "flux";
		$detector{"identifiers"} = "solidID";
		$detector{"style"}       = "1";
		print_det(\%configuration, \%detector);

		# bst tungsten shield
		my $shradius 	= 104/2;
		my $shthickness = 0.051/2.;
		my $outradius 	= $shradius + $shthickness;
		my $lenght 		= 180;
		my $shzpos      = 50;
		$detector{"name"}        = "Wshield";
		$detector{"mother"}      = "target";
		$detector{"description"} = "bst tungsten shield";
		$detector{"color"}       = "606564";
		$detector{"type"}        = "Tube";
		$detector{"pos"}         = "0 0 $shzpos*mm";
		$detector{"dimensions"}  = "$shradius*mm $outradius*mm $lenght*mm 0*deg 360*deg";
		$detector{"material"}    = "G4_W";
		$detector{"sensitivity"} = "flux";
		$detector{"hit_type"}    = "flux";
		$detector{"identifiers"} = "solidID";
		$detector{"style"}       = "1";
		print_det(\%configuration, \%detector);

	}

		if($thisVariation eq "lD2-empty")
	{
		my $nplanes = 4;

		my @oradius  =  (    55,   55,  21.1,  21.1 );
		# NOMINAL : (  -140.0,  265.0, 280.0, 280.0 );
		my @z_plane  =  (  -125.0,  265.0, 280.0, 280.0 );

		# vacuum target container
		my %detector = init_det();
		$detector{"name"}        = "target";
		$detector{"mother"}      = "root";
		$detector{"description"} = "Target Container";
		$detector{"color"}       = "22ff22";
		$detector{"type"}        = "Polycone";
		my $dimen = "0.0*deg 360*deg $nplanes*counts";
		for(my $i = 0; $i <$nplanes; $i++) {$dimen = $dimen ." 0.0*mm";}
		for(my $i = 0; $i <$nplanes; $i++) {$dimen = $dimen ." $oradius[$i]*mm";}
		for(my $i = 0; $i <$nplanes; $i++) {$dimen = $dimen ." $z_plane[$i]*mm";}
		$detector{"dimensions"}  = $dimen;
		$detector{"material"}    = "G4_Galactic";
		$detector{"style"}       = 0;
		print_det(\%configuration, \%detector);

		# reference foil
		my $thickness  = 0.01/2.;
		my $zpos       = 35;
		my $radius     = 7.3;
		$detector{"name"}        = "refFoil";
		$detector{"mother"}      = "target";
		$detector{"description"} = "aluminum refernence foil";
		$detector{"color"}       = "848789";
		$detector{"type"}        = "Tube";
		$detector{"pos"}         = "0 0 $zpos*mm";
		$detector{"dimensions"}  = "0*mm $radius*mm $thickness*mm 0*deg 360*deg";
		$detector{"material"}    = "G4_Al";
		$detector{"sensitivity"} = "flux";
		$detector{"hit_type"}    = "flux";
		$detector{"identifiers"} = "solidID";
		$detector{"style"}       = "1";
		print_det(\%configuration, \%detector);

	}
}

1;



















