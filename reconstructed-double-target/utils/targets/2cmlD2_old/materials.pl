use strict;
use warnings;

our %configuration;

sub materials
{
	my $thisVariation = $configuration{"variation"} ;
	my %mat = init_mat();
	# This conditional serves to build materials for all targets
	if($thisVariation ne " ")
	{
		# rohacell
		$mat{"name"}          = "rohacell";
		$mat{"description"}   = "target  rohacell scattering chamber material";
		$mat{"density"}       = "0.1";  # 100 mg/cm3
		$mat{"ncomponents"}   = "4";
		$mat{"components"}    = "G4_C 0.6465 G4_H 0.0784 G4_N 0.0839 G4_O 0.1912";
		print_mat(\%configuration, \%mat);

		# epoxy
		%mat = init_mat();
		$mat{"name"}          = "epoxy";
		$mat{"description"}   = "epoxy glue 1.16 g/cm3";
		$mat{"density"}       = "1.16";
		$mat{"ncomponents"}   = "4";
		$mat{"components"}    = "H 32 N 2 O 4 C 15";
		print_mat(\%configuration, \%mat);

		# fiberglass
		%mat = init_mat();
		$mat{"name"}          = "fiberglass";
		$mat{"description"}   = "fiberglass in fr4 g/cm3";
		$mat{"density"}       = "2.61";
		$mat{"ncomponents"}   = "4";
		$mat{"components"}    = "G4_SILICON_DIOXIDE 0.57 G4_CALCIUM_OXIDE 0.21 G4_ALUMINUM_OXIDE 0.14 G4_BORON_OXIDE 0.08";
		print_mat(\%configuration, \%mat);

		# FR4
		%mat = init_mat();
		$mat{"name"}          = "FR4";
		$mat{"description"}   = "FR4 for circuit boards g/cm3";
		$mat{"density"}       = "1.80";
		$mat{"ncomponents"}   = "2";
		$mat{"components"}    = "fiberglass 0.60 epoxy 0.40";
		print_mat(\%configuration, \%mat);

		# circuit board
		%mat = init_mat();
		$mat{"name"}          = "circuit_board";
		$mat{"description"}   = "Band made of fiberglass and cu g/cm3";
		$mat{"density"}       = "4.66";
		$mat{"ncomponents"}   = "2";
		$mat{"components"}    = "FR4 0.23 G4_Cu 0.77";
		print_mat(\%configuration, \%mat);

		# band
		%mat = init_mat();
		$mat{"name"}          = "band";
		$mat{"description"}   = "Band made of fiberglass and cu similar to circuit board but different proportions g/cm3";
		$mat{"density"}       = "2.99";
		$mat{"ncomponents"}   = "2";
		$mat{"components"}    = "FR4 0.50 G4_Cu 0.50";
		print_mat(\%configuration, \%mat);

		# carbon fiber
		%mat = init_mat();
		$mat{"name"}          = "carbonFiber";
		$mat{"description"}   = "carbon fiber material is epoxy and carbon - 1.75g/cm3";
		$mat{"density"}       = "1.75";
		$mat{"ncomponents"}   = "2";
		$mat{"components"}    = "G4_C 0.745 epoxy 0.255";
		print_mat(\%configuration, \%mat);

		# inox_steel
		%mat = init_mat();
		$mat{"name"}          = "inox_steel";
		$mat{"description"}   = "Inox steel 304 - g/cm3";
		$mat{"density"}       = "8.00";
		$mat{"ncomponents"}   = "3";
		$mat{"components"}    = "G4_Fe 0.72 G4_Cr 0.18 G4_Ni 0.10";
		print_mat(\%configuration, \%mat);

		# BeCu
		%mat = init_mat();
		$mat{"name"}          = "BeCu";
		$mat{"description"}   = "Beryllium-Copper alloy - g/cm3";
		$mat{"density"}       = "8.30";
		$mat{"ncomponents"}   = "2";
		$mat{"components"}    = "G4_Cu 0.98 G4_Be 0.02";
		print_mat(\%configuration, \%mat);

		# Bronze
		%mat = init_mat();
		$mat{"name"}          = "bronze";
		$mat{"description"}   = "Bronze - g/cm3";
		$mat{"density"}       = "8.00";
		$mat{"ncomponents"}   = "2";
		$mat{"components"}    = "G4_Cu 0.88 G4_Sn 0.12";
		print_mat(\%configuration, \%mat);

		# Piezomotor
		%mat = init_mat();
		$mat{"name"}          = "motor";
		$mat{"description"}   = "Whole motor condensed into one material - g/cm3";
		$mat{"density"}       = "8.20";
		$mat{"ncomponents"}   = "4";
		$mat{"components"}    = "G4_Cu 0.70 G4_Ni 0.20 fiberglass 0.05 epoxy 0.05 ";
		print_mat(\%configuration, \%mat);

		# torlon4435
		%mat = init_mat();
		$mat{"name"}          = "torlon4435";
		$mat{"description"}   = "torlon4435 - black (my guess) g/cm3";
		$mat{"density"}       = "1.59";
		$mat{"ncomponents"}   = "5";
		$mat{"components"}    = "H 4 N 2 O 3 C 9 Ar 1";
		print_mat(\%configuration, \%mat);

		# torlon4203
		%mat = init_mat();
		$mat{"name"}          = "torlon4203";
		$mat{"description"}   = "torlon4203 - yellow (my guess) g/cm3";
		$mat{"density"}       = "1.41";
		$mat{"ncomponents"}   = "5";
		$mat{"components"}    = "H 4 N 2 O 3 C 9 Ar 1";
		print_mat(\%configuration, \%mat);
	}
}