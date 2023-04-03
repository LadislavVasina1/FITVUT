/**
 * @project Modeling and simulation - Simulation of anti air missile defense system Iron Dome
 *
 * @file main.h
 * @author Ladislav Vašina, xvasin11@stud.fit.vutbr.cz
 * @author Dominik Vágner, xvagne10@stud.fit.vutbr.cz
 *
 */

#include <iostream>
#include <string>
#include <simlib.h>
#include <string.h>
#include <iomanip>

#define RED_BEGIN "\033[0;31m"
#define GREEN_BEGIN "\033[1;32m"
#define PURPLE_BEGIN "\033[1;35m"
#define CYAN_BEGIN "\033[1;36m"
#define COLOR_END "\033[0m"

#define DAY 86400 // seconds in day
#define QASSAM_CRITICAL 1.0/3.0
#define TAMIR_ACCURACY 0.9
#define QASSAM_PRICE 800
#define TAMIR_PRICE 125000
#define IDF_BUDGET 24300000000
#define ISRAEL_GDP 481590000000

using namespace std;

string optionToFind;

/**
 * Struct for storing program arguments
 * Arguments have default value in case user doesn't enter them
 */
struct argValues{
    // How many Qassams per day
    unsigned int R = 300;
    // How long it takes to fire all rockets per day [seconds]
    unsigned int Z = 21600;
    // Human error in BMC in %
    unsigned int J = 1;
    // Qassam failure rate in %
    unsigned int K = 20;
    // Qassams that need operator intervention in %
    unsigned int M = 5;
    // Normal time of Qassam flight [seconds]
    unsigned int N = 30;
    // Time to reload Iron Dome [seconds]
    unsigned int T = 1200;
};

extern int criticalTargetHits;
extern int qassamAimedAtNonCriticalTarget;
extern int qassamsDodgedIronDome;
extern int qassamsShotDown;
extern int failedInterceptionByTamir;
extern int missFiredTamirsDueToHumanError;
extern int rocketsTimedOut;
extern int tamirsFired;

extern int fellInGaza;
extern int flewToIsrael;
extern argValues args;

// Initialize radar store
Store radarStore("Radar", 1200); // p28
// Initialize BMC store (interception officers inside BMC)
Store bmcStore("BMC", 2); // p28

class IronDomeLauncher : public Process {
    public: int rocketMagazine = 20;

    void Behavior() {
        while(1) {
            if (rocketMagazine == 0) {
                Wait(args.T);
                rocketMagazine = 20;
            }
            Passivate();
            }
    }

    void GetRocketMagazine(int launcherID) {
        cout << launcherID << "# " <<Time <<" Left in mag " << rocketMagazine << endl;
    }
};

extern IronDomeLauncher *launcher01;
extern IronDomeLauncher *launcher02;
extern IronDomeLauncher *launcher03;


class RocketFlightTimeout: public Event {
    Process *rocket;
    public:
        RocketFlightTimeout(Process *rocket): rocket(rocket) {
            Activate(Time + Normal(args.N,  0.1 * args.N));
        }
    void Behavior() {
        delete rocket;
        if (Random() < 1 - QASSAM_CRITICAL) { // t38
            qassamAimedAtNonCriticalTarget++;
        } else { // t37
            criticalTargetHits++;
        }
	if (!bmcStore.Empty()) {
	    bmcStore.Leave(1);
	}
        radarStore.Leave(1);
        rocketsTimedOut++;
    }
};



class Qassam : public Process {
    void Behavior() {
        // Qassam waiting to be fired - p1
        Wait(Uniform(0, args.Z)); // t2
        // Initialize rocket flight timer
        Event *rft = new RocketFlightTimeout(this);
        if (Random() < (args.K * 0.01)) {
            // Qassam is destroyed
            fellInGaza++;
            delete rft;
            Cancel(); // t3
        } else { // t4
            // Qassam is not destroyed
            flewToIsrael++; // p29
            if (radarStore.Full()) { // t39
                if (Random() < (1 - QASSAM_CRITICAL)) { // t40
                    qassamAimedAtNonCriticalTarget++; // p34
                    delete rft;
                    Cancel();
                } else { // t41
                    criticalTargetHits++; // p35
                    delete rft;
                    Cancel();
                }
            } else { // p6
                Enter(radarStore, 1);
                if (Random() < (args.M * 0.01)) { // t7 Qassam needs operator intervention
                    Enter(bmcStore, 1); // t8
                    Wait(5); // t9
                    if (Random() < (args.J * 0.01)){ // t11
			if (!bmcStore.Empty()) {
                            Leave(bmcStore,  1);
			}
                        if (Random() < 1 - QASSAM_CRITICAL) {
                            criticalTargetHits++; // p27
                            Leave(radarStore, 1);
                            delete rft;
                            Cancel();
                        } else {
                            missFiredTamirsDueToHumanError++; // p24
                            if(launcher01->rocketMagazine) { // t23
                                launcher01->rocketMagazine--;
				tamirsFired++;
                                launcher01->Activate();
                            } else if(launcher02->rocketMagazine) { // t27
                                launcher02->rocketMagazine--;
				tamirsFired++;
                                launcher02->Activate();
                            } else if(launcher03->rocketMagazine) { // t31
                                launcher03->rocketMagazine--;
				tamirsFired++;
                                launcher03->Activate();
                            } else { // t42
                                qassamsDodgedIronDome++;
                                Leave(radarStore, 1);
                                qassamAimedAtNonCriticalTarget++;
                                delete rft;
                                Cancel();
                            }
                            qassamAimedAtNonCriticalTarget++;
                            Leave(radarStore, 1);
                            delete rft;
                            Cancel();
                        }
                    } else { // t10
			if (!bmcStore.Empty()) {
                            Leave(bmcStore,  1);
			}
                        goto p5;
                    }

                } else { // t6 Iron Dome will handle Qassam on its own
                    p5:
                    if (Random() < 1 - QASSAM_CRITICAL) { // t20
                        qassamAimedAtNonCriticalTarget++; // p6
                        Leave(radarStore, 1);
                        delete rft;
                        Cancel();
                    } else { // t21 - Handle critical Qassams
                        if(launcher01->rocketMagazine) { // t23
                            launcher01->rocketMagazine--;
			    tamirsFired++;
                            launcher01->Activate();
                        } else if(launcher02->rocketMagazine) { // t27
                            launcher02->rocketMagazine--;
			    tamirsFired++;
                            launcher02->Activate();
                        } else if(launcher03->rocketMagazine) { // t31
                            launcher03->rocketMagazine--;
			    tamirsFired++;
                            launcher03->Activate();
                        } else { // t42
                            criticalTargetHits++; // p36
                            qassamsDodgedIronDome++;
                            Leave(radarStore, 1);
                            delete rft;
                            Cancel();
                        }

                        if(Random() < TAMIR_ACCURACY) { // t17
                            delete rft;
                            qassamsShotDown++; // p26
                            Leave(radarStore, 1);
                            Cancel();
                        } else { // t16
                            delete rft;
                            failedInterceptionByTamir++;
                            criticalTargetHits++; // p27
                            Leave(radarStore, 1);
                            Cancel();
                        }
                    }
                }

                Leave(radarStore, 1);
                delete rft;
                Cancel();
            }
        }
    }
};


class QassamGenerator : public Event {
    void Behavior() {
        Qassam *qassam = new Qassam;
        qassam->Activate();
    }
};
