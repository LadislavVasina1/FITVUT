/**************************************/
/*         IPK - PROJECT1             */
/*     AUTHOR: LADISLAV VASINA        */
/*         LOGIN: XVASIN11            */
/*           YEAR: 2022               */
/**************************************/
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <stdbool.h>
#include <unistd.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <string.h>

// Custom function for converting char to long
static long parseLong(const char *str){
    char *temp;
    long val = strtol(str, &temp, 0);
    return val;
}

// Function for getting current CPU load
int cpu_load(){
    // Reading the first set of the cpu values that we will need for the computation
    FILE *previousStatsFd = popen("cat /proc/stat | head -n1", "r");
    char previousStats[200];
    fgets(previousStats, 200, previousStatsFd);
    pclose(previousStatsFd);

    usleep(200000); // Waiting to record next cpu values we need to compute cpu usage

    // Reading the seconds set of the cpu values that we will need for the computation
    FILE *currentStatsFd = popen("cat /proc/stat | head -n1", "r");
    char currentStats[200];
    fgets(currentStats, 200, currentStatsFd);
    pclose(currentStatsFd);

    // Getting current and previous cpu values

    /** USER values **/
    char userCmd[300];
    snprintf(userCmd, 300, "echo \"%s\" | awk -F \" \" '{print $2}'", currentStats);
    FILE *userFd = popen(userCmd, "r");
    char user[100];
    fgets(user, 100, userFd);
    pclose(userFd);

    char prevUserCmd[300];
    snprintf(prevUserCmd, 300, "echo \"%s\" | awk -F \" \" '{print $2}'", previousStats);
    FILE *prevUserFd = popen(prevUserCmd, "r");
    char prevUser[100];
    fgets(prevUser, 100, prevUserFd);
    pclose(prevUserFd);

    /** NICE values **/
    char niceCmd[300];
    snprintf(niceCmd, 300, "echo \"%s\" | awk -F \" \" '{print $3}'", currentStats);
    FILE *niceFd = popen(niceCmd, "r");
    char nice[100];
    fgets(nice, 100, niceFd);
    pclose(niceFd);

    char prevNiceCmd[300];
    snprintf(prevNiceCmd, 300, "echo \"%s\" | awk -F \" \" '{print $3}'", previousStats);
    FILE *prevNiceFd = popen(prevNiceCmd, "r");
    char prevNice[100];
    fgets(prevNice, 100, prevNiceFd);
    pclose(prevNiceFd);

    /** SYSTEM values **/
    char systemCmd[300];
    snprintf(systemCmd, 300, "echo \"%s\" | awk -F \" \" '{print $4}'", currentStats);
    FILE *systemFd = popen(systemCmd, "r");
    char system[100];
    fgets(system, 100, systemFd);
    pclose(systemFd);

    char prevSystemCmd[300];
    snprintf(prevSystemCmd, 300, "echo \"%s\" | awk -F \" \" '{print $4}'", previousStats);
    FILE *prevSystemFd = popen(prevSystemCmd, "r");
    char prevSystem[100];
    fgets(prevSystem, 100, prevSystemFd);
    pclose(prevSystemFd);

    /** IDLE values **/
    char idleCmd[300];
    snprintf(idleCmd, 300, "echo \"%s\" | awk -F \" \" '{print $5}'", currentStats);
    FILE *idleFd = popen(idleCmd, "r");
    char idle[100];
    fgets(idle, 100, idleFd);
    pclose(idleFd);

    char prevIdleCmd[300];
    snprintf(prevIdleCmd, 300, "echo \"%s\" | awk -F \" \" '{print $5}'", previousStats);
    FILE *prevIdleFd = popen(prevIdleCmd, "r");
    char prevIdle[100];
    fgets(prevIdle, 100, prevIdleFd);
    pclose(prevIdleFd);

    /** IOWAIT values **/
    char iowaitCmd[300];
    snprintf(iowaitCmd, 300, "echo \"%s\" | awk -F \" \" '{print $6}'", currentStats);
    FILE *iowaitFd = popen(iowaitCmd, "r");
    char iowait[100];
    fgets(iowait, 100, iowaitFd);
    pclose(iowaitFd);

    char prevIowaitCmd[300];
    snprintf(prevIowaitCmd, 300, "echo \"%s\" | awk -F \" \" '{print $6}'", previousStats);
    FILE *prevIowaitFd = popen(prevIowaitCmd, "r");
    char prevIowait[100];
    fgets(prevIowait, 100, prevIowaitFd);
    pclose(prevIowaitFd);

    /** IRQ values **/
    char irqCmd[300];
    snprintf(irqCmd, 300, "echo \"%s\" | awk -F \" \" '{print $7}'", currentStats);
    FILE *irqFd = popen(irqCmd, "r");
    char irq[100];
    fgets(irq, 100, irqFd);
    pclose(irqFd);

    char prevIrqCmd[300];
    snprintf(prevIrqCmd, 300, "echo \"%s\" | awk -F \" \" '{print $7}'", previousStats);
    FILE *prevIrqFd = popen(prevIrqCmd, "r");
    char prevIrq[100];
    fgets(prevIrq, 100, prevIrqFd);
    pclose(prevIrqFd);

    /** SOFTIRQ values **/
    char softirqCmd[300];
    snprintf(softirqCmd, 300, "echo \"%s\" | awk -F \" \" '{print $8}'", currentStats);
    FILE *softirqFd = popen(softirqCmd, "r");
    char softirq[100];
    fgets(softirq, 100, softirqFd);
    pclose(softirqFd);

    char prevSoftirqCmd[300];
    snprintf(prevSoftirqCmd, 300, "echo \"%s\" | awk -F \" \" '{print $8}'", previousStats);
    FILE *prevSoftirqFd = popen(prevSoftirqCmd, "r");
    char prevSoftirq[100];
    fgets(prevSoftirq, 100, prevSoftirqFd);
    pclose(prevSoftirqFd);

    /** STEAL values **/
    char stealCmd[300];
    snprintf(stealCmd, 300, "echo \"%s\" | awk -F \" \" '{print $9}'", currentStats);
    FILE *stealFd = popen(stealCmd, "r");
    char steal[100];
    fgets(steal, 100, stealFd);
    pclose(stealFd);

    char prevStealCmd[300];
    snprintf(prevStealCmd, 300, "echo \"%s\" | awk -F \" \" '{print $9}'", previousStats);
    FILE *prevStealFd = popen(prevStealCmd, "r");
    char prevSteal[100];
    fgets(prevSteal, 100, prevStealFd);
    pclose(prevStealFd);

    /** GUEST values **/
    char guestCmd[300];
    snprintf(guestCmd, 300, "echo \"%s\" | awk -F \" \" '{print $10}'", currentStats);
    FILE *guestFd = popen(guestCmd, "r");
    char guest[100];
    fgets(guest, 100, guestFd);
    pclose(guestFd);

    char prevGuestCmd[300];
    snprintf(prevGuestCmd, 300, "echo \"%s\" | awk -F \" \" '{print $10}'", previousStats);
    FILE *prevGuestFd = popen(prevGuestCmd, "r");
    char prevGuest[100];
    fgets(prevGuest, 100, prevGuestFd);
    pclose(prevGuestFd);

    /** GUEST_NICE values **/
    char guest_niceCmd[300];
    snprintf(guest_niceCmd, 300, "echo \"%s\" | awk -F \" \" '{print $11}'", currentStats);
    FILE *guest_niceFd = popen(guest_niceCmd, "r");
    char guest_nice[100];
    fgets(guest_nice, 100, guest_niceFd);
    pclose(guest_niceFd);

    char prevGuest_niceCmd[300];
    snprintf(prevGuest_niceCmd, 300, "echo \"%s\" | awk -F \" \" '{print $11}'", previousStats);
    FILE *prevGuest_niceFd = popen(prevGuest_niceCmd, "r");
    char prevGuest_nice[100];
    fgets(prevGuest_nice, 100, prevGuest_niceFd);
    pclose(prevGuest_niceFd);

    // Cpu usage calculation
    // Reference: https://stackoverflow.com/q/23367857
    long long int PrevIdle = parseLong(prevIdle) + parseLong(prevIowait);
    long long int Idle = parseLong(idle) + parseLong(iowait);
    long long int PrevNonIdle = parseLong(prevUser) + parseLong(prevNice) + parseLong(prevSystem) +
                                parseLong(prevIrq) + parseLong(prevSoftirq) + parseLong(prevSteal);
    long long int NonIdle = parseLong(user) + parseLong(nice) + parseLong(system) +
                            parseLong(irq) + parseLong(softirq) + parseLong(steal);
    long long int PrevTotal = PrevIdle + PrevNonIdle;
    long long int Total = Idle + NonIdle;
    long long int totald = Total - PrevTotal;
    long long int idled = Idle - PrevIdle;
    long long int load =((totald - idled)/(double)totald)*100;
    return load;
}


// Function for getting the model name of the computer CPU
char* cpu_name(){
    // Saving the result of the command getting our cpu's model name
    char * modelName;
    modelName = malloc(sizeof(char)*200);
    FILE *cpu = popen("cat /proc/cpuinfo | grep 'model name' | head -n 1 | sed 's:.*\\: ::'", "r");
    fgets(modelName, 200, cpu );
    pclose(cpu);
    return modelName;
}


// Function for getting the hostname of the computer
char* hostname() {
    char * hostName;
    hostName = malloc(sizeof(char)*200);
    FILE *cpu = popen("cat /proc/sys/kernel/hostname", "r");
    fgets(hostName, 200, cpu );
    pclose(cpu);
    return hostName;
}


// Function that checks if program argument is a number
bool isPortArgNumber(const char portArg[]){
    int i = 0;
    // Checking for negative numbers
    if (portArg[0] == '-'){
        return false;
    }
    for (; portArg[i] != 0; i++){
        if (!isdigit(portArg[i]))
            return false;
    }
    return true;
}


int main(int argc, char *argv[]) {
    /** THE BEGINNING OF THE ARGUMENT INPUT CHECKS **/
    if(argc != 2){
        fprintf( stderr, "!!!YOU NEED TO RUN THIS PROGRAM JUST WITH 1 ARGUMENT (port number)!!!\n");
        exit(EXIT_FAILURE);
    }
    if(!isPortArgNumber(argv[1])){
       fprintf( stderr, "!!!YOU NEED TO ENTER A NUMBER AS AN ARGUMENT (port number)!!!\n");
        exit(EXIT_FAILURE);
    }
    /** THE END OF THE ARGUMENT INPUT CHECKS **/

    int port = atoi(argv[1]);
    printf("USER DEFINED PORT: %d\n", port);

    /** SERVER **/

    struct sockaddr_in address;
    int opt = 1;
    int addrLen = sizeof(address);
    // Creation of socket file descriptor
    int serverFd;
    if((serverFd = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP)) <= 0){
        fprintf( stderr, "!!! SOCKET FAILED !!!\n");
        exit(EXIT_FAILURE);
    }
    if(setsockopt(serverFd, SOL_SOCKET, SO_REUSEADDR | SO_REUSEPORT, &opt, sizeof(opt))){
        fprintf( stderr, "!!! SETSOCKOPT FAILED !!!\n");
        exit(EXIT_FAILURE);
    }

    address.sin_family = AF_INET;
    address.sin_addr.s_addr = INADDR_ANY;
    address.sin_port = htons( port );

    // Attaching socket to the user defined port
    if(bind(serverFd, (struct sockaddr *)&address,sizeof(address))<0){
        fprintf( stderr, "!!! SOCKET BIND FAILED !!!\n");
        close(serverFd);
        exit(EXIT_FAILURE);
    }
    // Listening to the port
    if((listen(serverFd, 10)) < 0){
        fprintf( stderr, "!!! LISTENING FAILED !!!\n");
        close(serverFd);
        exit(EXIT_FAILURE);
    }

    int newSocket;
    char buffer[2048];
    while(true){
        newSocket = accept(serverFd, (struct sockaddr *)&address,(socklen_t*)&addrLen);
        if (newSocket < 0){
            fprintf( stderr, "!!! ACCEPT FAILED !!!\n");
            exit(EXIT_FAILURE);
        }
        printf("Got connection...\n");

        memset(buffer, 0, 2048);
        read(newSocket, buffer, 2047);
        printf("%s/n", buffer);

        // Implementation of server responses
        if(!strncmp(buffer, "GET /hostname", 13)){
            char * hostName = hostname();
            snprintf(buffer, sizeof(buffer), "HTTP/1.1 200 OK\r\nContent-Type: text/plain;\r\n\r\n");
            write(newSocket, buffer, strlen(buffer));
            write(newSocket, hostName, strlen(hostName));
            close(newSocket);
        }else if(!strncmp(buffer, "GET /cpu-name", 13)){
            char * modelName = cpu_name();
            snprintf(buffer, sizeof(buffer), "HTTP/1.1 200 OK\r\nContent-Type: text/plain;\r\n\r\n");
            write(newSocket, buffer, strlen(buffer));
            write(newSocket, modelName, strlen(modelName));
            close(newSocket);
        }else if(!strncmp(buffer, "GET /load", 9)){
            int cpuLoad = cpu_load();
            char cpuLoadBuff[100];
            sprintf(cpuLoadBuff, "%d%%", cpuLoad);
            snprintf(buffer, sizeof(buffer), "HTTP/1.1 200 OK\r\nContent-Type: text/plain;\r\n\r\n");
            write(newSocket, buffer, strlen(buffer));
            write(newSocket, cpuLoadBuff, strlen(cpuLoadBuff));
            close(newSocket);
        }else{
            char * badReq;
            badReq = "400 Bad Request";
            snprintf(buffer, sizeof(buffer), "HTTP/1.1 400 Bad Request\r\nContent-Type: text/plain;\r\n\r\n");
            write(newSocket, buffer, strlen(buffer));
            write(newSocket, badReq, strlen(badReq));
            close(newSocket);
        }

    }

    return 0;
}
