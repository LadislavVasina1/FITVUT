/**
 * @project Modeling and simulation - Simulation of anti air missile defense system Iron Dome
 *
 * @file main.cpp
 * @author Ladislav Vašina, xvasin11@stud.fit.vutbr.cz
 * @author Dominik Vágner, xvagne10@stud.fit.vutbr.cz
 *
 */

#include "main.h"

using namespace std;

argValues args;
// Function for easier program exiting
void exit_ims(string errorMessage) {
    fprintf(stderr,
            "%s%s \nALL ARGUMENTS ACCEPT INTEGERS ONLY%s%s\nUSAGE: ./main\n"
            " -R How many Qassams per day\n"
            " -Z How long it takes to fire all rockets per day [minutes] (max value is 1440)\n"
            " -J Percentage of human error in BMC\n"
            " -K Percentage of Qassam failure\n"
            " -M Percentage of Qassams that need operator intervention\n"
            " -N Normal time of Qassam flight [seconds]\n"
            " -T Time to reload Iron Dome [minutes]%s\n", RED_BEGIN, errorMessage.c_str(), COLOR_END, CYAN_BEGIN,
            COLOR_END);
    exit(EXIT_FAILURE);
}

// Function for printing out program arguments values
void outputProgramArgs() {
    cout << "+----------------------------------- " << CYAN_BEGIN << "ENTERED ARGS" << COLOR_END << " -----------------------------------+" << endl;
    cout << setfill(' ') << setw(60) << left << "| '-R' How many Qassams per day: ";
    printf("%27s", (to_string(args.R) + " Qassams/day |\n").c_str());
    cout << setfill(' ') << setw(60) << left << "| '-Z' How long it takes to fire all rockets per day: ";
    printf("%27s", (to_string(args.Z) + " sec |\n").c_str());
    cout << setfill(' ') << setw(60) << left << "| '-J' Percentage of human error in BMC: ";
    printf("%27s", (to_string(args.J) + " % |\n").c_str());
    cout << setfill(' ') << setw(60) << left << "| '-K' Percentage of Qassam failure: ";
    printf("%27s", (to_string(args.K) + " % |\n").c_str());
    cout << setfill(' ') << setw(60) << left << "| '-M' Percentage of Qassams that need operator intervention: ";
    printf("%25s", (to_string(args.M) + " % |\n").c_str());
    cout << setfill(' ') << setw(60) << left << "| '-N' Normal time of Qassam flight: ";
    printf("%27s", (to_string(args.N) + " sec |\n").c_str());
    cout << setfill(' ') << setw(60) << left << "| '-T' Time to reload Iron Dome: ";
    printf("%27s", (to_string(args.T) + " sec |\n").c_str());
    cout << "+" << setfill('-') << setw(85) << right << "+" << endl;
}


int fellInGaza;
int flewToIsrael;

int criticalTargetHits;
int qassamAimedAtNonCriticalTarget;
int qassamsDodgedIronDome;
int qassamsShotDown;
int failedInterceptionByTamir;
int missFiredTamirsDueToHumanError;
int rocketsTimedOut;
int tamirsFired;

IronDomeLauncher *launcher01;
IronDomeLauncher *launcher02;
IronDomeLauncher *launcher03;

int main(int argc, char *argv[]) {
    // Argument parser
    if (argc >= 2) {
        for (int i = 1; i < argc; i++) {
            optionToFind = string(argv[i]);
            // Help handler
            if (optionToFind == "-h" || optionToFind == "--help") {
                exit_ims("");
            }
            // Check -R option
            else if (optionToFind == "-R") {
                if (argv[i + 1] == nullptr) {
                    exit_ims("!!!You are missing argument for -R parameter!!!");
                }
                string tmp = argv[i + 1];
                if (tmp[0] == '-') {
                    exit_ims("!!!-R parameter can't be negative!!!");
                }
                args.R = atoi(argv[i + 1]);
            }
            // Check -Z option
            else if (optionToFind == "-Z") {
                if (argv[i + 1] == nullptr) {
                    exit_ims("!!!You are missing argument for -Z parameter!!!");
                }
                else if(atoi(argv[i + 1]) > 1440){
                    exit_ims("!!!-Z parameter can't be higher than 1440!!!");
                }
                string tmp = argv[i + 1];
                if (tmp[0] == '-') {
                    exit_ims("!!!-Z parameter can't be negative!!!");
                }
                args.Z = atoi(argv[i + 1]) * 60;
            }
            // Check -J option
            else if (optionToFind == "-J") {
                if (argv[i + 1] == nullptr) {
                    exit_ims("!!!You are missing argument for -J parameter!!!");
                }
                string tmp = argv[i + 1];
                if (atoi(argv[i + 1]) > 100  || tmp[0] == '-') {
                    exit_ims("!!!-J parameter must be between 0 and 100!!!");
                }
                args.J = stoul(argv[i + 1], nullptr, 10);
            }
            // Check -K option
            else if (optionToFind == "-K") {
                if (argv[i + 1] == nullptr) {
                    exit_ims("!!!You are missing argument for -K parameter!!!");
                }
                string tmp = argv[i + 1];
                if (atoi(argv[i + 1]) > 100  || tmp[0] == '-') {
                    exit_ims("!!!-K parameter must be between 0 and 100!!!");
                }
                args.K = atoi(argv[i + 1]);
            }
            // Check -M option
            else if (optionToFind == "-M") {
                if (argv[i + 1] == nullptr) {
                    exit_ims("!!!You are missing argument for -M parameter!!!");
                }
                string tmp = argv[i + 1];
                if (atoi(argv[i + 1]) > 100  || tmp[0] == '-') {
                    exit_ims("!!!-M parameter must be between 0 and 100!!!");
                }
                args.M = atoi(argv[i + 1]);
            }
            // Check -N option
            else if (optionToFind == "-N") {
                if (argv[i + 1] == nullptr) {
                    exit_ims("!!!You are missing argument for -N parameter!!!");
                }
                string tmp = argv[i + 1];
                if (tmp[0] == '-') {
                    exit_ims("!!!-N parameter can't be negative!!!");
                } else if (atoi(argv[i + 1]) == 0) {
                    exit_ims("!!!-N parameter must be higher than 0!!!");
                }
                args.N = atoi(argv[i + 1]);
            }
            // Check -T option
            else if (optionToFind == "-T") {
                if (argv[i + 1] == nullptr) {
                    exit_ims("!!!You are missing argument for -N parameter!!!");
                }
                string tmp = argv[i + 1];
                if (tmp[0] == '-') {
                    exit_ims("!!!-T parameter can't be negative!!!");
                }
                args.T = atoi(argv[i + 1]) * 60;
            }
        }
    }
    outputProgramArgs();

    Init(0, DAY);
    RandomSeed(time(nullptr));

    //Generating R Qassams
    for(unsigned int i = 0; i < args.R; i++){
        (new QassamGenerator)->Activate();
    }
    // Generating battery of launchers (3)
    launcher01 = new IronDomeLauncher;
    launcher02 = new IronDomeLauncher;
    launcher03 = new IronDomeLauncher;

    Run();

    int qassamCost = args.R * QASSAM_PRICE;
    int tamirCost = tamirsFired * TAMIR_PRICE;
    double crit_percentage = (double)criticalTargetHits / (double)(flewToIsrael - qassamAimedAtNonCriticalTarget) * 100;
    double idf_percentage = (double)tamirCost / (double)IDF_BUDGET * 100;
    double gdp_percentage = (double)tamirCost / (double)ISRAEL_GDP * 100;
    string rc(RED_BEGIN);
    string gc(GREEN_BEGIN);
    string pc(PURPLE_BEGIN);
    string ce(COLOR_END);

    cout << endl << "+----------------------------- " << CYAN_BEGIN << "IRON DOME BATTERY STATS" << COLOR_END << " ------------------------------+" << endl;
    cout << setfill(' ');
    printf("|%-95s|\n", (pc + " Qassam Failures: " + ce).c_str());
    printf("|%-84s|\n", ("  - Reached Israel: " + to_string(flewToIsrael)).c_str());
    printf("|%-84s|\n", ("  - Fell in Gaza: " + to_string(fellInGaza)).c_str());
    printf("|%-84s|\n", "");
    printf("|%-95s|\n", (pc + " Qassam Targets: " + ce).c_str());
    printf("|%-84s|\n", ("  - Aimed at critical target: " + to_string(flewToIsrael - qassamAimedAtNonCriticalTarget)).c_str());
    printf("|%-84s|\n", ("  - Not aimed at critical target: " + to_string(qassamAimedAtNonCriticalTarget)).c_str());
    printf("|%-84s|\n", "");
    printf("|%-95s|\n", (pc + " Iron Dome Interceptions: " + ce).c_str());
    printf("|%-84s|\n", ("  - Tamirs launched: " + to_string(tamirsFired)).c_str());
    printf("|%-95s|\n", ("  - Qassams intercepted: " + gc + to_string(qassamsShotDown) + ce).c_str());
    printf("|%-95s|\n", ("  - Critical target hits: " + rc + to_string(criticalTargetHits) + ce).c_str());
    printf("|%-95s|\n", ("  - Critical target hit percentage: " + rc + to_string(crit_percentage) + " %" + ce).c_str());
    printf("|%-84s|\n", ("  - Qassams not intercepted due to launchers reloading: " + to_string(qassamsDodgedIronDome)).c_str());
    printf("|%-84s|\n", "");
    printf("|%-95s|\n", (pc + " BMC (Battle Management & Weapon Control unit): " + ce).c_str());
    printf("|%-84s|\n", ("  - Missfired Tamir rockets due to human error: " + to_string(missFiredTamirsDueToHumanError)).c_str());
    printf("|%-84s|\n", ("  - Qassams not processed by BMC, operators took too long: " + to_string(rocketsTimedOut)).c_str());
    printf("|%-84s|\n", "");
    printf("|%-95s|\n", (pc + " Attack and Defence Cost: " + ce).c_str());
    printf("|%-84s|\n", ("  - Price of Qassams: " + to_string(qassamCost) + " $").c_str());
    printf("|%-84s|\n", ("  - Price of Tamirs: " + to_string(tamirCost) + " $").c_str());
    printf("|%-84s|\n", ("  - Price of Tamirs to IDF budget: " + to_string(idf_percentage) + " %").c_str());
    printf("|%-84s|\n", ("  - Price of Tamirs to Israel GDP: " + to_string(gdp_percentage) + " %").c_str());
    printf("|%-84s|\n", "");
    cout << "+" << setfill('-') << setw(85) << right << "+" << endl;
    return 0;
}
