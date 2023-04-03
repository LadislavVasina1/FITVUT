#!/bin/bash
# TESTS FOR feedreader.cpp made by Ladislav Vašina, xvasin11

RED_BEGIN="\033[0;31m"
CYAN_BEGIN="\033[1;36m"
GREEN_BEGIN="\033[1;32m"
YELLOW_BEGIN="\033[1;33m"
PURPLE_BEGIN="\033[1;35m"
BLUE_BEGIN="\033[1;34m"
COLOR_END="\033[0m"
PASSED=0
FAILED=0

echo -e "$PURPLE_BEGIN*********************************************$COLOR_END"
TEST_NAME="NO_FEEDFILE"
CMD="./feedreader 'https://www.feedforall.com/sample-feed.xml' -f"
echo -e "${BLUE_BEGIN}$TEST_NAME test ran:\n$YELLOW_BEGIN${CMD}$COLOR_END"
echo -e "${BLUE_BEGIN}PROGRAM OUTPUT:$COLOR_END"
eval $CMD
status=$?
if [ $status -eq 0 ]; then
    echo -e "${RED_BEGIN}TEST RESULT: \"${TEST_NAME}\" TEST FAILED $COLOR_END"
    FAILED=$((FAILED+1))
else
    echo -e "${GREEN_BEGIN}TEST RESULT: \"${TEST_NAME}\" TEST PASSED $COLOR_END"
    PASSED=$((PASSED+1))
fi
echo -e "$PURPLE_BEGIN*********************************************$COLOR_END"


echo -e "$PURPLE_BEGIN*********************************************$COLOR_END"
TEST_NAME="NON_EXISTENT_FEEDFILE"
CMD="./feedreader 'https://www.feedforall.com/sample-feed.xml' -f non_existent_file.txt"
echo -e "${BLUE_BEGIN}$TEST_NAME test ran:\n$YELLOW_BEGIN${CMD}$COLOR_END"
echo -e "${BLUE_BEGIN}PROGRAM OUTPUT:$COLOR_END"
eval $CMD
status=$?
if [ $status -eq 0 ]; then
    echo -e "${RED_BEGIN}TEST RESULT: \"${TEST_NAME}\" TEST FAILED $COLOR_END"
    FAILED=$((FAILED+1))
else
    echo -e "${GREEN_BEGIN}TEST RESULT: \"${TEST_NAME}\" TEST PASSED $COLOR_END"
    PASSED=$((PASSED+1))
fi
echo -e "$PURPLE_BEGIN*********************************************$COLOR_END"


echo -e "$PURPLE_BEGIN*********************************************$COLOR_END"
TEST_NAME="NO_CERTFILE"
CMD="./feedreader 'https://www.feedforall.com/sample-feed.xml' -c"
echo -e "${BLUE_BEGIN}$TEST_NAME test ran:\n$YELLOW_BEGIN${CMD}$COLOR_END"
echo -e "${BLUE_BEGIN}PROGRAM OUTPUT:$COLOR_END"
eval $CMD
status=$?
if [ $status -eq 0 ]; then
    echo -e "${RED_BEGIN}TEST RESULT: \"${TEST_NAME}\" TEST FAILED $COLOR_END"
    FAILED=$((FAILED+1))
else
    echo -e "${GREEN_BEGIN}TEST RESULT: \"${TEST_NAME}\" TEST PASSED $COLOR_END"
    PASSED=$((PASSED+1))
fi
echo -e "$PURPLE_BEGIN*********************************************$COLOR_END"


echo -e "$PURPLE_BEGIN*********************************************$COLOR_END"
TEST_NAME="NO_CERTDIR"
CMD="./feedreader 'https://www.feedforall.com/sample-feed.xml' -C"
echo -e "${BLUE_BEGIN}INCORRECT_CERDIR test ran:\n$YELLOW_BEGIN${CMD}$COLOR_END"
echo -e "${BLUE_BEGIN}PROGRAM OUTPUT:$COLOR_END"
eval $CMD
status=$?
if [ $status -eq 0 ]; then
    echo -e "${RED_BEGIN}TEST RESULT: \"INCORRECT CERTDIR\" TEST FAILED $COLOR_END"
    FAILED=$((FAILED+1))
else
    echo -e "${GREEN_BEGIN}TEST RESULT: \"INCORRECT CERTDIR\" TEST PASSED $COLOR_END"
    PASSED=$((PASSED+1))
fi
echo -e "$PURPLE_BEGIN*********************************************$COLOR_END"


echo -e "$PURPLE_BEGIN*********************************************$COLOR_END"
TEST_NAME="INVALID_URL"
CMD="./feedreader 'httpXXXs://www.feedforall.com/sample-feed.xml'"
echo -e "${BLUE_BEGIN}${TEST_NAME} test ran:\n$YELLOW_BEGIN${CMD}$COLOR_END"
echo -e "${BLUE_BEGIN}PROGRAM OUTPUT:$COLOR_END"
eval $CMD
status=$?
if [ $status -eq 0 ]; then
    echo -e "${RED_BEGIN}TEST RESULT: \"${TEST_NAME}\" TEST FAILED $COLOR_END"
    FAILED=$((FAILED+1))
else
    echo -e "${GREEN_BEGIN}TEST RESULT: \"${TEST_NAME}\" TEST PASSED $COLOR_END"
    PASSED=$((PASSED+1))
fi
echo -e "$PURPLE_BEGIN*********************************************$COLOR_END"


echo -e "$PURPLE_BEGIN*********************************************$COLOR_END"
TEST_NAME="NO_XML_IN_RESPONSE"
CMD="./feedreader 'https://www.fit.vut.cz'"
echo -e "${BLUE_BEGIN}${TEST_NAME} test ran:\n$YELLOW_BEGIN${CMD}$COLOR_END"
echo -e "${BLUE_BEGIN}PROGRAM OUTPUT:$COLOR_END"
eval $CMD
status=$?
if [ $status -eq 0 ]; then
    echo -e "${RED_BEGIN}TEST RESULT: \"${TEST_NAME}\" TEST FAILED $COLOR_END"
    FAILED=$((FAILED+1))
else
    echo -e "${GREEN_BEGIN}TEST RESULT: \"${TEST_NAME}\" TEST PASSED $COLOR_END"
    PASSED=$((PASSED+1))
fi
echo -e "$PURPLE_BEGIN*********************************************$COLOR_END"


echo -e "$PURPLE_BEGIN*********************************************$COLOR_END"
TEST_NAME="INCORRECT_CERTDIR"
CMD="./feedreader 'https://www.feedforall.com/sample-feed.xml' -u -T -C /dev/null"
echo -e "${BLUE_BEGIN}${TEST_NAME} test ran:\n$YELLOW_BEGIN${CMD}$COLOR_END"
echo -e "${BLUE_BEGIN}PROGRAM OUTPUT:$COLOR_END"
eval $CMD
status=$?
if [ $status -eq 0 ]; then
    echo -e "${RED_BEGIN}TEST RESULT: \"${TEST_NAME}\" TEST FAILED $COLOR_END"
    FAILED=$((FAILED+1))
else
    echo -e "${GREEN_BEGIN}TEST RESULT: \"${TEST_NAME}\" TEST PASSED $COLOR_END"
    PASSED=$((PASSED+1))
fi
echo -e "$PURPLE_BEGIN*********************************************$COLOR_END"

echo -e "$PURPLE_BEGIN*********************************************$COLOR_END"
TEST_NAME="INCORRECT_CERTFILE"
CMD="./feedreader 'https://www.feedforall.com/sample-feed.xml' -u -T -c /dev/null"
echo -e "${BLUE_BEGIN}${TEST_NAME} test ran:\n$YELLOW_BEGIN${CMD}$COLOR_END"
echo -e "${BLUE_BEGIN}PROGRAM OUTPUT:$COLOR_END"
eval $CMD
status=$?
if [ $status -eq 0 ]; then
    echo -e "${RED_BEGIN}TEST RESULT: \"${TEST_NAME}\" TEST FAILED $COLOR_END"
    FAILED=$((FAILED+1))
else
    echo -e "${GREEN_BEGIN}TEST RESULT: \"${TEST_NAME}\" TEST PASSED $COLOR_END"
    PASSED=$((PASSED+1))
fi
echo -e "$PURPLE_BEGIN*********************************************$COLOR_END"


echo -e "$PURPLE_BEGIN*********************************************$COLOR_END"
TEST_NAME="ATOM_FEED_OUTPUT_NO_ARG"
CMD="./feedreader https://www.pgaction.org/about/atom.xml"
echo -e "${BLUE_BEGIN}${TEST_NAME} test ran:\n$YELLOW_BEGIN${CMD}$COLOR_END"
echo -e "${BLUE_BEGIN}PROGRAM OUTPUT:$COLOR_END"
eval $CMD
EXPECTED_OUTPUT="*** About Us ***
How We Work
Our Partners
Our Donors
Who We Are
Our History and Achievements
Contact Us
Employment & Internships"
EXPECTED_OUTPUT_CMD=$(echo $EXPECTED_OUTPUT > expected.txt)
echo -e "${BLUE_BEGIN}EXPECTED OUTPUT:$COLOR_END\n$EXPECTED_OUTPUT"

TMPCMP="diff -b expected.txt <(./feedreader https://www.pgaction.org/about/atom.xml)"
status=$?
if [ $status -ne 0 ]; then
    echo -e "${RED_BEGIN}TEST RESULT: \"${TEST_NAME}\" TEST FAILED $COLOR_END"
    FAILED=$((FAILED+1))
else
    echo -e "${GREEN_BEGIN}TEST RESULT: \"${TEST_NAME}\" TEST PASSED $COLOR_END"
    PASSED=$((PASSED+1))
fi
echo -e "$PURPLE_BEGIN*********************************************$COLOR_END"



echo -e "$PURPLE_BEGIN*********************************************$COLOR_END"
TEST_NAME="RSS_FEED_OUTPUT"
CMD="./feedreader "https://www.feedforall.com/sample-feed.xml" -u -T "
echo -e "${BLUE_BEGIN}${TEST_NAME} test ran:\n$YELLOW_BEGIN${CMD}$COLOR_END"
echo -e "${BLUE_BEGIN}PROGRAM OUTPUT:$COLOR_END"
eval $CMD
EXPECTED_OUTPUT="*** Sample Feed - Favorite RSS Related Software & Resources ***
RSS Resources
URL: http://www.feedforall.com
Aktualizace: Tue, 26 Oct 2004 14:01:01 -0500

Recommended Desktop Feed Reader Software
URL: http://www.feedforall.com/feedforall-partners.htm
Aktualizace: Tue, 26 Oct 2004 14:03:25 -0500

Recommended Web Based Feed Reader Software
URL: http://www.feedforall.com/feedforall-partners.htm
Aktualizace: Tue, 26 Oct 2004 14:06:44 -0500
"
EXPECTED_OUTPUT_CMD=$(echo $EXPECTED_OUTPUT > expected.txt)
echo -e "${BLUE_BEGIN}EXPECTED OUTPUT:$COLOR_END\n$EXPECTED_OUTPUT"

TMPCMP="diff -b expected.txt <(./feedreader "https://www.feedforall.com/sample-feed.xml" -u -T )"
status=$?
eval "rm expected.txt"
if [ $status -ne 0 ]; then
    echo -e "${RED_BEGIN}TEST RESULT: \"${TEST_NAME}\" TEST FAILED $COLOR_END"
    FAILED=$((FAILED+1))
else
    echo -e "${GREEN_BEGIN}TEST RESULT: \"${TEST_NAME}\" TEST PASSED $COLOR_END"
    PASSED=$((PASSED+1))
fi
echo -e "$PURPLE_BEGIN*********************************************$COLOR_END"

echo -e "$PURPLE_BEGIN\n@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@$COLOR_END"
echo -e "$PURPLE_BEGIN@@@@@@@@@@@@@@${COLOR_END}TEST SUMMARY$PURPLE_BEGIN@@@@@@@@@@@@@@@@@@@$COLOR_END"
echo -e "$PURPLE_BEGIN@@@@@@@@@@@@@@$COLOR_END${GREEN_BEGIN}PASSED: $PASSED  $PURPLE_BEGIN@@@@@@@@@@@@@@@@@@@$COLOR_END"
echo -e "$PURPLE_BEGIN@@@@@@@@@@@@@@$COLOR_END${RED_BEGIN}FAILED: $FAILED   $PURPLE_BEGIN@@@@@@@@@@@@@@@@@@@$COLOR_END"
echo -e "$PURPLE_BEGIN@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@$COLOR_END"






