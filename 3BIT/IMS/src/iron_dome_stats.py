import os
import subprocess
import time


def get_stats():
    runs_dict = {
        "100": [],
        "200": [],
        "300": [],
        "500": [],
        "750": [],
        "1000": [],
        "1500": [],
        "2000": [],
        "2500": [],
        "3000": [],
        "4000": [],
        "5000": [],
        "7500": [],
        "10000": [],
        "12500": [],
        "15000": [],
        "17500": [],
        "20000": [],
        "25000": [],
        "30000": [],
    }
    for key, value in runs_dict.items():
        for i in range(10):
            output = os.popen(f"./main -Z 1440 -R {key}").readlines()
            time.sleep(1);
            percentage = str(output[23]).split("%")[0].split("m")[-1].strip()
            value.append(float(percentage))
        avg = sum(value) / 10
        print(f"{key}: ".ljust(10), "{:.3f}".format(avg).rjust(10))

def specific_run(R="300", Z="360", J="1", K="20", M="5", N="30", T="20"):
    reached_israel = []
    fell_in_gaza = []
    aimed_at_critical = []
    not_aimed = []
    tamirs_launched = []
    qassams_intercepted = []
    critical_target_hits = []
    critical_hit_percentage = []
    qassams_not_intercepted = []
    missfired_tamir = []
    qassams_not_processed_BMC = []
    price_of_qassams = []
    price_of_tamirs = []
    price_of_tamirs_to_IDF = []
    price_of_tamirs_to_GDP = []
    for i in range(10):
        output = os.popen(f"./main -R {R} -Z {Z} -J {J} -K {K} -M {M} -N {N} -T {T}").readlines()
        time.sleep(1)
        reached_israel.append(int(output[12].split()[4]))
        fell_in_gaza.append(int(output[13].split()[5]))
        aimed_at_critical.append(int(output[16].split()[6]))
        not_aimed.append(int(output[17].split()[7]))
        tamirs_launched.append(int(output[20].split()[4]))
        qassams_intercepted.append(int(output[21].split()[4].split("m")[1][:-3]))
        critical_target_hits.append(int(output[22].split()[5].split("m")[1][:-3]))
        critical_hit_percentage.append(float((output[23]).split("%")[0].split("m")[-1].strip()))
        qassams_not_intercepted.append(int(output[24].split()[9]))
        missfired_tamir.append(int(output[27].split()[9]))
        qassams_not_processed_BMC.append(int(output[28].split()[11]))
        price_of_qassams.append(int(output[31].split()[5]))
        price_of_tamirs.append(int(output[32].split()[5]))
        price_of_tamirs_to_IDF.append(float(output[33].split()[8]))
        price_of_tamirs_to_GDP.append(float(output[34].split()[8]))
    print(f"reached_israel:  {sum(reached_israel) / 10}")
    print(f"fell_in_gaza:  {sum(fell_in_gaza) / 10}")
    print(f"aimed_at_critical:  {sum(aimed_at_critical) / 10}")
    print(f"not_aimed:  {sum(not_aimed) / 10}")
    print(f"tamirs_launched:  {sum(tamirs_launched) / 10}")
    print(f"qassams_intercepted:  {sum(qassams_intercepted) / 10}")
    print(f"critical_target_hits:  {sum(critical_target_hits) / 10}")
    print(f"critical_hit_percentage:  {sum(critical_hit_percentage) / 10.0}")
    print(f"qassams_not_intercepted:  {sum(qassams_not_intercepted) / 10}")
    print(f"missfired_tamirs:  {sum(missfired_tamir) / 10}")
    print(f"qassams_not_processed:  {sum(qassams_not_processed_BMC) / 10}")
    print(f"price_of_qassams:  {sum(price_of_qassams) / 10}")
    print(f"price_of_tamirs:  {sum(price_of_tamirs) / 10}")
    print(f"price_of_tamirs_to_IDF:  {sum(price_of_tamirs_to_IDF) / 10.0}")
    print(f"price_of_tamirs_to_GDP:  {sum(price_of_tamirs_to_GDP) / 10.0}")

if __name__ == "__main__":
    #get_stats()
    specific_run()
