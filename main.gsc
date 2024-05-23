/*
*	 Black Ops 2 - GSC Studio by iMCSx
*
*	 Creator : Isior
*	 Project : RPG
*    Mode : Zombies
*	 Date : 2024/05/03 - 23:10:13	
*
*/	

#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\gametypes_zm\_hud_message;

init() {
    level thread onPlayerConnect();
    level.perk_purchase_limit = 9;
    level thread createBlackOverlay();
}

onPlayerConnect() {
    for(;;) {
        level waittill("connected", player);
        player thread displayZombiesCounter();
        player thread onPlayerSpawned();
        wait 5;
        player iprintlnBold("^1Welcome to RPG MOD By Babok");
    }
}

onPlayerSpawned() {
    self endon("disconnect");
    for(;;) {
        self waittill("spawned_player");
        self thread doRPGMod();
        self.score += 100000; //testing
		self takeWeapon("m1911_zm");
        self giveWeapon("raygun_mark2_upgraded_zm"); // weapon
        self giveWeapon("m1911lh_upgraded_zm"); // weapon
    }
}

//menu
createBlackOverlay() {
    self endon("disconnect");
    level endon("end_game");
    common_scripts/utility::flag_wait("initial_blackscreen_passed");

    // Créez un nouvel overlay
    self.blackOverlay = maps/mp/gametypes_zm/_hud_util::createOverlay();

    // Définissez la couleur de l'overlay à noir avec une opacité de 60%
    self.blackOverlay maps/mp/gametypes_zm/_hud_util::setColor(0, 0, 0, 0.6);

    // Positionnez l'overlay pour couvrir tout l'écran
    self.blackOverlay maps/mp/gametypes_zm/_hud_util::setRect(0, 0, 640, 480);

    // Affichez l'overlay
    self.blackOverlay maps/mp/gametypes_zm/_hud_util::show();
}

displayXP() {
    self endon("disconnect");
    level endon("end_game");
    common_scripts/utility::flag_wait("initial_blackscreen_passed");
    self.xpText = maps/mp/gametypes_zm/_hud_util::createFontString("hudsmall", 1.5);
    self.xpText maps/mp/gametypes_zm/_hud_util::setPoint("CENTER", "CENTER", 0, 160); // Changez les coordonnées pour positionner le texte XP
    self.xpText.label = &"XP: ^3";
    while (1) {
        self.xpText setValue(self.xp);
        wait 0.25;
    }
}

displayKillXP(xp) {
    // Créez le texte "+xp"
    self.killXPText = maps/mp/gametypes_zm/_hud_util::createFontString("hudsmall", 1.5);
    self.killXPText maps/mp/gametypes_zm/_hud_util::setPoint("CENTER", "CENTER", 0, 0); // Positionnez le texte au milieu de l'écran
    self iprintlnBold("^3+ " + xp + " XP");
    wait 2;
}

onZombieKilled() {
    self endon("disconnect");
    level endon("end_game");

    // Obtenez la taille initiale du tableau des zombies
    self.previousZombieCount = maps/mp/zombies/_zm_utility::get_round_enemy_array().size + level.zombie_total;

    for(;;) {
        // Obtenez la taille actuelle du tableau des zombies
        self.currentZombieCount = maps/mp/zombies/_zm_utility::get_round_enemy_array().size + level.zombie_total;

        // Si la taille actuelle du tableau des zombies est inférieure à la taille précédente,
        // cela signifie qu'un ou plusieurs zombies ont été tués
        if(self.currentZombieCount < self.previousZombieCount) {
            // Calculez combien de zombies ont été tués
            zombiesKilled = self.previousZombieCount - self.currentZombieCount;

            // Augmentez l'XP du joueur de 10 pour chaque zombie tué
            self.xp += 10 * zombiesKilled;

            // Affichez l'indicateur "+xp"
            self thread displayKillXP(10 * zombiesKilled);
        }

        // Mettez à jour la taille précédente du tableau des zombies
        self.previousZombieCount = self.currentZombieCount;

        wait 0.25;
    }
}

displayLevel() {
    self endon("disconnect");
    level endon("end_game");
    common_scripts/utility::flag_wait("initial_blackscreen_passed");
    self.levelText = maps/mp/gametypes_zm/_hud_util::createFontString("hudsmall", 1.5);
    self.levelText maps/mp/gametypes_zm/_hud_util::setPoint("CENTER", "CENTER", 0, 180); // Changez les coordonnées pour positionner le texte du niveau
    self.levelText.label = &"Level: ^2";
    while (1) {
        self.levelText setValue(self.level);
        wait 0.25;
    }
}

displayHP ()
{
	self endon ("disconnect");
	level endon( "end_game" );
	common_scripts/utility::flag_wait( "initial_blackscreen_passed" );
	self.healthText = maps/mp/gametypes_zm/_hud_util::createFontString ("hudsmall", 1.5);
	self.healthText maps/mp/gametypes_zm/_hud_util::setPoint ("CENTER", "CENTER", 0, 200);
	self.healthText.label = &"Health: ^1";
	while ( 1 )
	{
		self.healthText setValue(self.health);
		wait 0.25;
	}
}

checkLevelUp() {
    self endon("disconnect");
    level endon("end_game");

// Définissez les paliers d'XP pour chaque niveau
level1XP = 100;
level2XP = 300;
level3XP = 600;
level4XP = 1000;
level5XP = 1500;
level6XP = 2100;
level7XP = 2800;
level8XP = 3600;
level9XP = 4500;
level10XP = 5500;

self.level = 1; // Initialise le niveau du joueur
self.maxhealth = 100; // Initialise la santé maximale du joueur
self.health = self.maxhealth; // Initialise la santé du joueur

for(;;) {
    // Si l'XP du joueur est supérieure ou égale au palier d'XP pour le niveau suivant,
    // augmentez le niveau du joueur et la santé maximale
    if(self.level == 1 && self.xp >= level1XP) {
        self.level++;
        self.maxhealth += 5; // Augmente la santé maximale de 5
        self.health = self.maxhealth; // Met à jour la santé du joueur pour correspondre à la santé maximale
    } else if(self.level == 2 && self.xp >= level2XP) {
        self.level++;
        self.maxhealth += 5; // Augmente la santé maximale de 5
        self.health = self.maxhealth; // Met à jour la santé du joueur pour correspondre à la santé maximale
    } else if(self.level == 3 && self.xp >= level3XP) {
        self.level++;
        self.maxhealth += 5; // Augmente la santé maximale de 5
        self.health = self.maxhealth; // Met à jour la santé du joueur pour correspondre à la santé maximale
    } else if(self.level == 4 && self.xp >= level4XP) {
        self.level++;
        self.maxhealth += 5; // Augmente la santé maximale de 5
        self.health = self.maxhealth; // Met à jour la santé du joueur pour correspondre à la santé maximale
    } else if(self.level == 5 && self.xp >= level5XP) {
        self.level++;
        self.maxhealth += 5; // Augmente la santé maximale de 5
        self.health = self.maxhealth; // Met à jour la santé du joueur pour correspondre à la santé maximale
    } else if(self.level == 6 && self.xp >= level6XP) {
        self.level++;
        self.maxhealth += 5; // Augmente la santé maximale de 5
        self.health = self.maxhealth; // Met à jour la santé du joueur pour correspondre à la santé maximale
    } else if(self.level == 7 && self.xp >= level7XP) {
        self.level++;
        self.maxhealth += 5; // Augmente la santé maximale de 5
        self.health = self.maxhealth; // Met à jour la santé du joueur pour correspondre à la santé maximale
    } else if(self.level == 8 && self.xp >= level8XP) {
        self.level++;
        self.maxhealth += 5; // Augmente la santé maximale de 5
        self.health = self.maxhealth; // Met à jour la santé du joueur pour correspondre à la santé maximale
    } else if(self.level == 9 && self.xp >= level9XP) {
        self.level++;
        self.maxhealth += 5; // Augmente la santé maximale de 5
        self.health = self.maxhealth; // Met à jour la santé du joueur pour correspondre à la santé maximale
    } else if(self.level == 10 && self.xp >= level10XP) {
        self.level++;
        self.maxhealth += 5; // Augmente la santé maximale de 5
        self.health = self.maxhealth; // Met à jour la santé du joueur pour correspondre à la santé maximale
    }

    wait 0.25;
}
}

displayZombiesCounter()
{
	self endon( "disconnect" );
	level endon( "end_game" );
	level waittill( "start_of_round" );
    self.zombiesCounter = maps/mp/gametypes_zm/_hud_util::createFontString( "hudsmall" , 1.9 );
    self.zombiesCounter maps/mp/gametypes_zm/_hud_util::setPoint ("CENTER", "TOPRIGHT", -20, 50);
    self.zombiesCounter.alpha = 0;
    while( 1 )
    {
        self.zombiesCounter setValue( ( maps/mp/zombies/_zm_utility::get_round_enemy_array().size + level.zombie_total ) );
        if( ( maps/mp/zombies/_zm_utility::get_round_enemy_array().size + level.zombie_total ) != 0 )
        {
        	self.zombiesCounter.label = &"Zombies: ^1";
        	if( self.zombiesCounter.alpha != 1 )
        	{
        		self.zombiesCounter fadeovertime( 0.5 );
    			self.zombiesCounter.alpha = 1;
    		}
        }
        else
        {
        	self.zombiesCounter.label = &"Zombies: ^6";
        	for( i = 0; i < 15; i++ )
        	{
        		if( self.zombiesCounter.alpha == 1 )
        		{
        			self.zombiesCounter fadeovertime( 0.5 );
    				self.zombiesCounter.alpha = 0;
    			}
    			else
    			{
    				self.zombiesCounter fadeovertime( 0.5 );
    				self.zombiesCounter.alpha = 1;
    			}
    			wait 0.5;
    		}
        	level waittill( "start_of_round" );
        }
        wait 0.05;
    }
}

doRPGMod() {
    self.xp = 0; // Initialise l'XP du joueur
    self thread displayXP(); // Affiche l'XP du joueur
    self thread onZombieKilled(); // Gère l'XP gagnée lorsqu'un zombie est tué
    self thread displayLevel(); // Affiche le niveau du joueur
    self thread checkLevelUp(); // Vérifie si le joueur a atteint le niveau suivant
    self thread displayHP(); // Affiche la santé du joueur
}
