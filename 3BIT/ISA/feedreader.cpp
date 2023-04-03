/**************************************/
/*          ISA - PROJECT             */
/*           RSS/ATOM READER          */
/*     AUTHOR: LADISLAV VASINA        */
/*         LOGIN: XVASIN11            */
/*           YEAR: 2022               */
/**************************************/

// Example feeds to try:
// ./feedreader "https://news.yahoo.com/rss/" -u -a -T
// ./feedreader "https://www.feedforall.com/sample-feed.xml" -u -a -T
// ./feedreader "http://feeds.bbci.co.uk/news/world/rss.xml" -u -a -T
// ./feedreader "https://what-if.xkcd.com/feed.atom" -u -a -T
// ./feedreader "https://news.yahoo.com/rss/" -u -a -T -C /etc/ssl/certs

#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>
#include <pcap.h>
#include <string>
#include <ctype.h>
#include <sstream>
#include <regex>
#include <iostream>
#include <fstream>
#include <libxml/parser.h>
#include <libxml/tree.h>
#include <vector>
// OpenSSL headers
#include "openssl/bio.h"
#include "openssl/ssl.h"
#include "openssl/err.h"

#define RED_BEGIN "\033[0;31m"
#define CYAN_BEGIN "\033[1;36m"
#define COLOR_END "\033[0m"
#define BUFFER_SIZE 2048

using namespace std;

// Setting up program flags
bool rssFormatFlag = false;
bool atomFormatFlag = false;
bool urlFlag = false;
bool sslFlag = false;
bool feedFileFlag = false;
bool certFileFlag = false;
bool certDirFlag = false;
bool timeFlag = false;
bool authorFlag = false;
bool showUrlFlag = false;
bool connectionVerified = false;
bool portEntered = false;

string optionToFind;
string urlToFind;
string url;
string fqdn;
string port;
string sitePath;
string feedFile;
string certFile;
string certDir;

BIO *bio = nullptr;
SSL_CTX *ctx = nullptr;
SSL *ssl;
xmlDocPtr doc;

// Function for easier sniffer exiting
void exit_feed(string errorMessage){
    fprintf(stderr,
            "%s%s %s\n%sPOUZITI: ./feedreader"
            " <URL | -f <feedfile>>"
            " [-c <certfile>]"
            " [-C <certaddr>]"
            " [-T]"
            " [-a]"
            " [-u]%s\n", RED_BEGIN, errorMessage.c_str(), COLOR_END, CYAN_BEGIN, COLOR_END);
    exit(EXIT_FAILURE);
}

// Function for removing new line characters from string
void rm_nl(string &s) {
    s = regex_replace(s, regex("\\r\\n|\\r|\\n"), "");
}


// Function for printing rss2 feed
void print_rss(xmlNode *root){
    string feedTitle;
    // Iterating through all nodes and looking for channel node
    for(xmlNode *rootNode = root->children; rootNode; rootNode = rootNode->next){
        if (!xmlStrcasecmp(rootNode->name, (xmlChar *) "channel")){
            // Iterating through all channel children nodes and looking for title node
            for(xmlNode *channelNode = rootNode->children; channelNode; channelNode = channelNode->next){
                if (!xmlStrcasecmp(channelNode->name, (xmlChar *) "title")){
                    feedTitle = (char *) channelNode->children->content;
                    cout << "*** " << feedTitle << " ***" << endl;
                    break;
                }
            }
        }
    }
    // Now we iterate further
    for(xmlNode *rootNode = root->children; rootNode; rootNode = rootNode->next){
        // And we are looking for item node
        if(!xmlStrcasecmp(rootNode->name, (xmlChar *) "channel")){
            string nodeContent;
            // Now we iterate through item node children and print its children's values
            for(xmlNode *channelNode = rootNode->children; channelNode; channelNode = channelNode->next){
                if(!xmlStrcasecmp(channelNode->name,(xmlChar *) "item")){
                    for(xmlNode *itemNode = channelNode->children; itemNode; itemNode = itemNode->next) {
                        if(!xmlStrcasecmp(itemNode->name, (xmlChar *) "title")){
                            nodeContent = (char *)xmlNodeGetContent(itemNode);
                            if(!showUrlFlag && !timeFlag && !authorFlag){
                                cout << nodeContent;
                            }else{
                                cout << nodeContent << endl;
                            }
                        }
                        if(showUrlFlag){
                            if(!xmlStrcasecmp(itemNode->name, (xmlChar *) "link")){
                                nodeContent = (char *)xmlNodeGetContent(itemNode);
                                if(!showUrlFlag && !timeFlag && !authorFlag){
                                    cout << "\nURL: " << nodeContent << endl;
                                }else{
                                    cout << "URL: " << nodeContent << endl;
                                }
                            }
                        }
                        if(timeFlag){
                            if(!xmlStrcasecmp(itemNode->name, (xmlChar *) "pubDate")){
                                nodeContent = (char *)xmlNodeGetContent(itemNode);
                                cout << "Aktualizace: " << nodeContent << endl;
                            }
                        }
                        if(authorFlag){
                            if(!xmlStrcasecmp(itemNode->name, (xmlChar *) "managingEditor") ||
                               !xmlStrcasecmp(itemNode->name, (xmlChar *) "author")){
                                nodeContent = (char *)xmlNodeGetContent(itemNode);
                                cout << "Autor: " << nodeContent << endl;
                            }
                        }
                    }
                    cout << endl;
                }
            }
        }
    }
}


// Function for printing atom feed
void print_atom(xmlNode *root){
    string feedTitle;
    // Iterating through all nodes and looking for first title node. This node contains feed title.
    for(xmlNode *rootNode = root->children; rootNode; rootNode = rootNode->next){
        if (!xmlStrcasecmp(rootNode->name, (xmlChar *) "title")){
            feedTitle = (char *) xmlNodeGetContent(rootNode);
            if(!feedTitle.empty()){
                cout << "*** " << feedTitle << " ***" << endl;
                break;
            }else{
                cerr << RED_BEGIN << !"!!!Název nenalezen!!" << COLOR_END << endl;
            }
        }
    }
    // Now we iterate further
    for(xmlNode *rootNode = root->children; rootNode; rootNode = rootNode->next){
        // And we are looking for entry node
        if(!xmlStrcasecmp(rootNode->name, (xmlChar *) "entry")){
            string nodeContent;
            string entryUrl;
            // Now we iterate through entry node children and print its children's values
            for(xmlNode *entryNode = rootNode->children; entryNode; entryNode = entryNode->next) {
                if(!xmlStrcasecmp(entryNode->name, (xmlChar *) "title")){
                    nodeContent = (char *)xmlNodeGetContent(entryNode);
                    if(!showUrlFlag && !timeFlag && !authorFlag){
                        cout << nodeContent;
                    }else{
                        cout << nodeContent << endl;
                    }
                }
                if(showUrlFlag){
                    if(!xmlStrcasecmp(entryNode->name, (xmlChar *) "link")){
                        entryUrl = (char *) xmlGetProp(entryNode, (xmlChar *) "href");
                        if(!showUrlFlag && !timeFlag && !authorFlag){
                            cout << "\nURL: " << entryUrl << endl;
                        }else{
                            cout << "URL: " << entryUrl << endl;
                        }
                    }
                }
                if(timeFlag){
                    if(!xmlStrcasecmp(entryNode->name, (xmlChar *) "updated")){
                        nodeContent = (char *)xmlNodeGetContent(entryNode);
                        cout << "Aktualizace: " << nodeContent << endl;
                    }
                }
                if(authorFlag){
                    // Here we have to iterate through "author" node because "name" and "email" are nested inside it
                    if(!xmlStrcasecmp(entryNode->name, (xmlChar *) "author")){
                        for(xmlNode *authorNode = entryNode->children; authorNode; authorNode = authorNode->next){
                            if(!xmlStrcasecmp(authorNode->name, (xmlChar *) "name")){
                                nodeContent = (char *)xmlNodeGetContent(authorNode);
                                cout << "Autor: " << nodeContent << endl;
                            }
                            if(!xmlStrcasecmp(authorNode->name, (xmlChar *) "email")){
                                nodeContent = (char *)xmlNodeGetContent(authorNode);
                                cout << "Email: " << nodeContent << endl;
                            }
                        }
                    }
                }
            }
            cout << endl;
        }
    }
}


// Function for checking the feed type
void check_feed_format(xmlNode * node){
    xmlNode *currentNode = NULL;
    for (currentNode = node; currentNode; currentNode = currentNode->next) {
        if (currentNode->type == XML_ELEMENT_NODE) {
            if (strcmp((char*)currentNode->name, "feed") == 0){
                atomFormatFlag = true;
            }
            if (strcmp((char*)currentNode->name, "rss") == 0){
                rssFormatFlag = true;
            }
        }
        check_feed_format(currentNode->children);
    }
}

bool make_conn_parse(){
    // Initializing OpenSSL library
    SSL_library_init();
    SSL_load_error_strings();
    ERR_load_BIO_strings();
    OpenSSL_add_all_algorithms();

    // If secure connection is NOT used
    if(sslFlag == false){
        if(portEntered){
            bio = BIO_new_connect((fqdn + ":" + port).c_str());
        }else{
            bio = BIO_new_connect((fqdn + ":80").c_str());
        }
        // Handle the failure
        if(bio == nullptr){
            exit_feed("!!!BIO_new_connect selhalo!!!");
        }
        if(BIO_do_connect(bio) <= 0){
            exit_feed("!!!BIO_do_connect selhalo - Nelze vytvořit spojení!!!");
        }
    }// If secure connection IS used
    else if(sslFlag == true){
        ctx = SSL_CTX_new(SSLv23_client_method());
        if(!ctx){
            exit_feed("!!!SSL_CTX_new selhalo - Nepodařilo se vytvořit kontext!!!");
        }

        // Try to verify the connection
        if(certFileFlag == true){
            if(!SSL_CTX_load_verify_locations(ctx, certFile.c_str(), nullptr)){
                exit_feed("!!!SSL_CTX_load_verify_locations(file) selhalo!!!");
            }
        }else if(certDirFlag == true){
            if(!SSL_CTX_load_verify_locations(ctx, nullptr, certDir.c_str())){
                exit_feed("!!!SSL_CTX_load_verify_locations(folder) selhalo!!!");
            }
        }else if(certFileFlag && certDirFlag){
            if(!SSL_CTX_load_verify_locations(ctx, certFile.c_str(), certDir.c_str())){
                exit_feed("!!!SSL_CTX_load_verify_locations(file, folder) selhalo!!!");
            }
        }else if(!certFileFlag && !certDirFlag){
            if(!SSL_CTX_set_default_verify_paths(ctx)){
                exit_feed("!!!SSL_CTX_set_default_verify_paths selhalo!!!");
            }
        }

        // If we have not failed with ssl verification at this point, we have succeeded with verification
        connectionVerified = true;
        // Create a new BIO
        bio = BIO_new_ssl_connect(ctx);

        BIO_get_ssl(bio, &ssl);
        SSL_set_mode(ssl, SSL_MODE_AUTO_RETRY);

        // Attempt to connect
        if(portEntered){
            BIO_set_conn_hostname(bio, (fqdn + ":" + port).c_str());
        }else{
            BIO_set_conn_hostname(bio, (fqdn + ":443").c_str());
        }

        // Verify that the connection hase been opened and perform the handshake
        if(BIO_do_connect(bio) <= 0){
            exit_feed("!!!BIO_do_connect selhalo - Nelze vytvořit zabezpečené spojení!!!");
        }
        if(SSL_get_verify_result(ssl) != X509_V_OK){
            exit_feed("!!!SLL_get_verify_result selhalo - Nelze ověřit certifikát!!!");
        }
    }
    // Creating HTTP request
    string writeBuffer = "GET " + sitePath + " HTTP/1.0\r\n"
                         "Host: " + fqdn + "\r\n"
                         "Connection: close\r\n"
                         "\r\n";

    // Attempt to write len bytes from buffer to BIO
    if(BIO_write(bio, writeBuffer.c_str(), writeBuffer.length()) <= 0){
        exit_feed("!!!BIO_write selhalo - Nelze zapsat do BIO!!!");
    }
    int size;
    char buffer[BUFFER_SIZE];
    string httpResponse;

    // Read response message
    for(;;){
        size = BIO_read(bio, buffer, BUFFER_SIZE - 1);
        // If no more data --> exit loop
        if(size <= 0){
            break;
        }
        // Terminate the string
        buffer[size] = '\0';
        // Append part of the response to the httpResponse string
        httpResponse = httpResponse + buffer;
    }

    string sanitizedResponse;
    // We try to find the first occurrence of the string <?xml
    int startPos = httpResponse.find("<?xml");
    if(startPos < 0){
        if(feedFileFlag){
            cerr << RED_BEGIN << !"!!!XML nenalezen v odpovědi!!\nZkouším další url..." << COLOR_END << endl;
            return false;
        }else{
            exit_feed("!!!XML nenalezen v odpovědi!!!");
        }
    }
    string feed;
    if(startPos > 0){
        feed = httpResponse.erase(0, startPos);
    }

    xmlKeepBlanksDefault(0);
    doc = xmlParseDoc((const xmlChar *) feed.c_str());
    if(doc == nullptr){
        if(!feedFileFlag){
            exit_feed("!!!Nepodařilo se rozparsovat dokument!!!");
        }
    }
    xmlNode *root_element = NULL;
    // Get the root element node
    root_element = xmlDocGetRootElement(doc);
    check_feed_format(root_element);

    if(atomFormatFlag){
        print_atom(root_element);
    }else if(rssFormatFlag){
        print_rss(root_element);
    }
    return true;
}


// Function for checking if the URLs in feedfile are valid
void check_feed_file_urls(vector <string> feedFileContent){
    string urlToCheck;
    for(long unsigned int k = 0; k < feedFileContent.size(); k++){
        urlToCheck = feedFileContent[k];
        regex url_regex(
                R"(^(https?)://([^:?#/]+)(:([0-9]+))?(.*)$)",
                regex::extended);
        smatch url_match_result;
        if(regex_match(urlToCheck, url_match_result, url_regex)){
            url = url_match_result[0];
            fqdn = url_match_result[2];
            port = url_match_result[4];
            sitePath = url_match_result[5];
            rm_nl(url);
            rm_nl(fqdn);
            rm_nl(port);
            rm_nl(sitePath);
            if(port != ""){
                portEntered = true;
            }
            if(sitePath == ""){
                sitePath = "/";
            }
            // Checking if https is used
            if(url_match_result[1].length() == 5){
                sslFlag = true;
            }
            //urlFlag = true;
            if(urlFlag && feedFileFlag){
                exit_feed("!!!Nelze použít jak URL, tak feedfile!!!");
            }
        }else{
            cerr << RED_BEGIN << " Nevalidní URL ve feedfilu " << COLOR_END << endl;
        }
        make_conn_parse();
    }
}


// Main program function
int main(int argc, char *argv[]){

    vector <string> feedFileContent;
    // Argument parser
    if(argc == 1){
        exit_feed("!!!Nebyly uvedeny žádné argumenty!!!");
    }
    if(argc >= 2){
        for(int i = 1; i < argc; i++){
            optionToFind = string(argv[i]);
            // Help handler
            if(optionToFind == "-h" || optionToFind == "--help"){
                exit_feed("");
            }
            // Check -f option
            else if(optionToFind == "-f") {
                if (argv[i + 1] == nullptr) {
                    exit_feed("!!!Chybí argument pro -f parametr!!!");
                }
                feedFileFlag = true;
                feedFile = string(argv[i + 1]);
                // File handling
                ifstream input_stream(feedFile);
                if (!input_stream) {
                    exit_feed("!!!Nelze otevřít daný soubor!!!");
                }
                string line;
                while (getline(input_stream, line)) {
                    // Strip comments from the file
                    if(line[0] == '#') continue;
                    // Strip empty lines from the file
                    if(line[0] == '\n') continue;
                    feedFileContent.push_back(line + "\n");
                }
            }
                // Check -c option
            else if(optionToFind == "-c"){
                if(argv[i+1] == nullptr){
                    exit_feed("!!!Chybí argument pro -c parametr!!!");
                }
                certFile = argv[i+1];
                certFileFlag = true;
            }
                // Check -C option
            else if(optionToFind == "-C"){
                if(argv[i+1] == nullptr){
                    exit_feed("!!!Chybí argument pro for -C parametr!!!");
                }
                certDir = argv[i+1];
                certDirFlag = true;
            }
                // Check -T option
            else if(optionToFind == "-T"){
                timeFlag = true;
            }
                // Check -a option
            else if(optionToFind == "-a"){
                authorFlag = true;
            }// Check -u option
            else if(optionToFind == "-u"){
                showUrlFlag = true;
            }
        }

        if(feedFileFlag){
            check_feed_file_urls(feedFileContent);
        }

        // Check if URL is entered as an argument using regex
        for (int j = 1; j < argc; j++) {
            urlToFind = string(argv[j]);
            regex url_regex(
                    R"(^(https?)://([^:?#/]+)(:([0-9]+))?(.*)$)",
                    regex::extended);
            smatch url_match_result;
            if(regex_match(urlToFind, url_match_result, url_regex)){
                url = url_match_result[0];
                fqdn = url_match_result[2];
                port = url_match_result[4];
                sitePath = url_match_result[5];
                if(port != ""){
                    portEntered = true;
                }
                if(sitePath == ""){
                    sitePath = "/";
                }
                // Checking if https is used
                if(url_match_result[1].length() == 5){
                    sslFlag = true;
                }
                urlFlag = true;
                break;
            }else{
                if(!feedFileFlag){
                    exit_feed("!!!Nevalidní URL!!!");
                }
            }
        }
    }
    if(!feedFileFlag){
        make_conn_parse();
    }

    xmlFreeDoc(doc);       // free document
    xmlCleanupParser();    // Free globals
    BIO_free_all(bio);
    SSL_CTX_free(ctx);
    return 0;
}
