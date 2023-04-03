/*
File containing some javascript for website

@author: Dominik Vágner
@email: xvagne10@stud.fit.vutbr.cz
*/

$(document).ready(async function () {
    if (window.location.pathname === '/new_ticket') {
        const lat = document.getElementById("latitude");
        const long = document.getElementById("longitude");

        let center = SMap.Coords.fromWGS84(15.7774239, 50.0375792);

        let nt_map = new SMap(JAK.gel("new-ticket-map"), center, 13);
        nt_map.addDefaultLayer(SMap.DEF_OPHOTO);
        nt_map.addDefaultLayer(SMap.DEF_OPHOTO0203);
        nt_map.addDefaultLayer(SMap.DEF_OPHOTO0406);
        nt_map.addDefaultLayer(SMap.DEF_TURIST);
        nt_map.addDefaultLayer(SMap.DEF_TURIST_WINTER);
        nt_map.addDefaultLayer(SMap.DEF_HISTORIC);
        nt_map.addDefaultLayer(SMap.DEF_BASE).enable();
        nt_map.addDefaultControls();

        let layerSwitch = new SMap.Control.Layer({
            width: 65,
            items: 4,
            page: 4
        });
        layerSwitch.addDefaultLayer(SMap.DEF_BASE);
        layerSwitch.addDefaultLayer(SMap.DEF_OPHOTO);
        layerSwitch.addDefaultLayer(SMap.DEF_TURIST);
        layerSwitch.addDefaultLayer(SMap.DEF_TURIST_WINTER);
        layerSwitch.addDefaultLayer(SMap.DEF_OPHOTO0406);
        layerSwitch.addDefaultLayer(SMap.DEF_OPHOTO0203);
        layerSwitch.addDefaultLayer(SMap.DEF_HISTORIC);
        nt_map.addControl(layerSwitch, {left: "8px", top: "9px"});

        let mouse = new SMap.Control.Mouse(SMap.MOUSE_PAN | SMap.MOUSE_WHEEL | SMap.MOUSE_ZOOM); /* Ovládání myší */
        nt_map.addControl(mouse);

        let nt_layer = new SMap.Layer.Marker();
        nt_map.addLayer(nt_layer).enable();

        let mark = new SMap.Marker(center);
        mark.decorate(SMap.Marker.Feature.Draggable);
        nt_layer.addMarker(mark);

        function start(e) {
            let node = e.target.getContainer();
            node[SMap.LAYER_MARKER].style.cursor = "help";
        }

        function stop(e) {
            let node = e.target.getContainer();
            node[SMap.LAYER_MARKER].style.cursor = "";
            let coords = e.target.getCoords();
            new SMap.Geocoder.Reverse(coords, change_location);
            lat.value = coords.y;
            long.value = coords.x;
        }

        function map_click(e, elm) {
            nt_layer.removeAll()
            let coords = SMap.Coords.fromEvent(e.data.event, nt_map);
            let mark = new SMap.Marker(coords);
            mark.decorate(SMap.Marker.Feature.Draggable);
            nt_layer.addMarker(mark);
            new SMap.Geocoder.Reverse(coords, change_location);
            lat.value = coords.y;
            long.value = coords.x;
        }

        let change_location = function (geocoder) {
            let results = geocoder.getResults();
            const new_ticket_location = document.getElementById("new-ticket-location")
            new_ticket_location.innerText = results.label
        }

        document.getElementById("map-my-location").addEventListener("click", map_my_location)
        function map_my_location() {
            let latitude;
            let longitude;
            const successCallback = (position) => {
                latitude = position.coords.latitude;
                longitude = position.coords.longitude;

                nt_layer.removeAll()
                let coords = SMap.Coords.fromWGS84(longitude, latitude);
                let mark = new SMap.Marker(coords);
                mark.decorate(SMap.Marker.Feature.Draggable);
                nt_layer.addMarker(mark);
                nt_map.setCenter(coords)

                new SMap.Geocoder.Reverse(coords, change_location);
                lat.value = coords.y;
                long.value = coords.x;
            };

            const errorCallback = (error) => {
              console.log(error);
            };

            const id = navigator.geolocation.getCurrentPosition(successCallback, errorCallback);
            navigator.geolocation.clearWatch(id);
        }

        let signals = nt_map.getSignals();
        signals.addListener(window, "marker-drag-stop", stop);
        signals.addListener(window, "marker-drag-start", start);
        signals.addListener(window, "map-click", map_click);
    }

    if (window.location.pathname === '/map_of_tickets') {
        let center = SMap.Coords.fromWGS84(15.7774239, 50.0375792);

        let map = new SMap(JAK.gel("map-of-tickets"), center, 13);
        map.addDefaultLayer(SMap.DEF_OPHOTO);
        map.addDefaultLayer(SMap.DEF_OPHOTO0203);
        map.addDefaultLayer(SMap.DEF_OPHOTO0406);
        map.addDefaultLayer(SMap.DEF_TURIST);
        map.addDefaultLayer(SMap.DEF_TURIST_WINTER);
        map.addDefaultLayer(SMap.DEF_HISTORIC);
        map.addDefaultLayer(SMap.DEF_BASE).enable();
        map.addDefaultControls();

        let layerSwitch = new SMap.Control.Layer({
            width: 65,
            items: 4,
            page: 4
        });
        layerSwitch.addDefaultLayer(SMap.DEF_BASE);
        layerSwitch.addDefaultLayer(SMap.DEF_OPHOTO);
        layerSwitch.addDefaultLayer(SMap.DEF_TURIST);
        layerSwitch.addDefaultLayer(SMap.DEF_TURIST_WINTER);
        layerSwitch.addDefaultLayer(SMap.DEF_OPHOTO0406);
        layerSwitch.addDefaultLayer(SMap.DEF_OPHOTO0203);
        layerSwitch.addDefaultLayer(SMap.DEF_HISTORIC);
        map.addControl(layerSwitch, {left: "8px", top: "9px"});

        let mouse = new SMap.Control.Mouse(SMap.MOUSE_PAN | SMap.MOUSE_WHEEL | SMap.MOUSE_ZOOM);
        map.addControl(mouse);

        let marker_layer = new SMap.Layer.Marker();
        map.addLayer(marker_layer).enable();

        let clusterer = new SMap.Marker.Clusterer(map);
        marker_layer.setClusterer(clusterer);

        const response = await get_tickets();
        let tickets = eval(response);
        tickets.forEach(function(value) {
            let c = new SMap.Card();
            c.setSize(350, 200);
            c.getHeader().innerHTML = "<strong>Category:</strong> " + value.name ;
            c.getBody().style.margin = "5px 0px";
            c.getBody().style.backgroundColor = "ddd";
            c.getBody().innerHTML = "<strong>Created at:</strong> " + value.created_at + "<br>"
            c.getBody().innerHTML += "<strong>Descirption:</strong> " + value.description;
            c.getFooter().innerHTML = " <strong>View ticket:</strong> <a href='" +
                                      window.location.origin + "/ticket_view?ticketID="
                                      + value.id + "'>Here" + "</a>"

            let coords = SMap.Coords.fromWGS84(value.longitude, value.latitude);

            const dom = document.createElement('div');
            dom.className = 'svg-marker';

            if(value.state === "NEW") {
                dom.style = "fill: #ff0315";
                dom.classList.add("marker-new");
            } else if(value.state === "PLANNED") {
                dom.style = "fill: #1f80ff";
                dom.classList.add("marker-planned");
            } else if(value.state === "WORK_IN_PROGRESS") {
                dom.style = "fill: #ff7c00";
                dom.classList.add("marker-wip");
            } else {
                dom.style = 'fill: #00ae67';
                dom.classList.add("marker-done");
            }

            dom.innerHTML = `<svg xmlns="http://www.w3.org/2000/svg" width="40" height="40" class="bi bi-geo-alt-fill" viewBox="0 0 16 16">
                                  <path d="M8 16s6-5.686 6-10A6 6 0 0 0 2 6c0 4.314 6 10 6 10zm0-7a3 3 0 1 1 0-6 3 3 0 0 1 0 6z"/>
                             </svg>`;

            let options = {
                url: dom
            };

            let mark = new SMap.Marker(coords, "markerId" + value.id, options);
            mark.decorate(SMap.Marker.Feature.Card, c);
            marker_layer.addMarker(mark);
        });

        let signals = map.getSignals();
    }

    if (window.location.pathname === "/manager_ticket_view") {
        const lat = parseFloat(document.getElementById("latitude").innerText);
        const long = parseFloat(document.getElementById("longitude").innerText);

        let center = SMap.Coords.fromWGS84(long, lat);

        let manager_map = new SMap(JAK.gel("manager-ticket-view-map"), center, 13);
        manager_map.addDefaultLayer(SMap.DEF_OPHOTO);
        manager_map.addDefaultLayer(SMap.DEF_OPHOTO0203);
        manager_map.addDefaultLayer(SMap.DEF_OPHOTO0406);
        manager_map.addDefaultLayer(SMap.DEF_TURIST);
        manager_map.addDefaultLayer(SMap.DEF_TURIST_WINTER);
        manager_map.addDefaultLayer(SMap.DEF_HISTORIC);
        manager_map.addDefaultLayer(SMap.DEF_BASE).enable();
        manager_map.addDefaultControls();

        let layerSwitch = new SMap.Control.Layer({
            width: 65,
            items: 4,
            page: 4
        });
        layerSwitch.addDefaultLayer(SMap.DEF_BASE);
        layerSwitch.addDefaultLayer(SMap.DEF_OPHOTO);
        layerSwitch.addDefaultLayer(SMap.DEF_TURIST);
        layerSwitch.addDefaultLayer(SMap.DEF_TURIST_WINTER);
        layerSwitch.addDefaultLayer(SMap.DEF_OPHOTO0406);
        layerSwitch.addDefaultLayer(SMap.DEF_OPHOTO0203);
        layerSwitch.addDefaultLayer(SMap.DEF_HISTORIC);
        manager_map.addControl(layerSwitch, {left: "8px", top: "9px"});

        let mouse = new SMap.Control.Mouse(SMap.MOUSE_PAN | SMap.MOUSE_WHEEL | SMap.MOUSE_ZOOM);
        manager_map.addControl(mouse);

        let manager_map_layer = new SMap.Layer.Marker();
        manager_map.addLayer(manager_map_layer).enable();

        let manager_mark = new SMap.Marker(center);
        manager_map_layer.addMarker(manager_mark);
    }

    if (window.location.pathname === "/ticket_view") {
        const lat = parseFloat(document.getElementById("latitude").innerText);
        const long = parseFloat(document.getElementById("longitude").innerText);

        let center = SMap.Coords.fromWGS84(long, lat);

        let ticket_map = new SMap(JAK.gel("ticket-view-map"), center, 13);
        ticket_map.addDefaultLayer(SMap.DEF_OPHOTO);
        ticket_map.addDefaultLayer(SMap.DEF_OPHOTO0203);
        ticket_map.addDefaultLayer(SMap.DEF_OPHOTO0406);
        ticket_map.addDefaultLayer(SMap.DEF_TURIST);
        ticket_map.addDefaultLayer(SMap.DEF_TURIST_WINTER);
        ticket_map.addDefaultLayer(SMap.DEF_HISTORIC);
        ticket_map.addDefaultLayer(SMap.DEF_BASE).enable();
        ticket_map.addDefaultControls();

        let layerSwitch = new SMap.Control.Layer({
            width: 65,
            items: 4,
            page: 4
        });
        layerSwitch.addDefaultLayer(SMap.DEF_BASE);
        layerSwitch.addDefaultLayer(SMap.DEF_OPHOTO);
        layerSwitch.addDefaultLayer(SMap.DEF_TURIST);
        layerSwitch.addDefaultLayer(SMap.DEF_TURIST_WINTER);
        layerSwitch.addDefaultLayer(SMap.DEF_OPHOTO0406);
        layerSwitch.addDefaultLayer(SMap.DEF_OPHOTO0203);
        layerSwitch.addDefaultLayer(SMap.DEF_HISTORIC);
        ticket_map.addControl(layerSwitch, {left: "8px", top: "9px"});

        let mouse = new SMap.Control.Mouse(SMap.MOUSE_PAN | SMap.MOUSE_WHEEL | SMap.MOUSE_ZOOM);
        ticket_map.addControl(mouse);

        let ticket_map_layer = new SMap.Layer.Marker();
        ticket_map.addLayer(ticket_map_layer).enable();

        let ticket_mark = new SMap.Marker(center);
        ticket_map_layer.addMarker(ticket_mark);
    }

    if (window.location.pathname === "/task_view") {
        const lat = parseFloat(document.getElementById("latitude").innerText);
        const long = parseFloat(document.getElementById("longitude").innerText);

        let center = SMap.Coords.fromWGS84(long, lat);

        let task_map = new SMap(JAK.gel("task-view-map"), center, 13);
        task_map.addDefaultLayer(SMap.DEF_OPHOTO);
        task_map.addDefaultLayer(SMap.DEF_OPHOTO0203);
        task_map.addDefaultLayer(SMap.DEF_OPHOTO0406);
        task_map.addDefaultLayer(SMap.DEF_TURIST);
        task_map.addDefaultLayer(SMap.DEF_TURIST_WINTER);
        task_map.addDefaultLayer(SMap.DEF_HISTORIC);
        task_map.addDefaultLayer(SMap.DEF_BASE).enable();
        task_map.addDefaultControls();

        let layerSwitch = new SMap.Control.Layer({
            width: 65,
            items: 4,
            page: 4
        });
        layerSwitch.addDefaultLayer(SMap.DEF_BASE);
        layerSwitch.addDefaultLayer(SMap.DEF_OPHOTO);
        layerSwitch.addDefaultLayer(SMap.DEF_TURIST);
        layerSwitch.addDefaultLayer(SMap.DEF_TURIST_WINTER);
        layerSwitch.addDefaultLayer(SMap.DEF_OPHOTO0406);
        layerSwitch.addDefaultLayer(SMap.DEF_OPHOTO0203);
        layerSwitch.addDefaultLayer(SMap.DEF_HISTORIC);
        task_map.addControl(layerSwitch, {left: "8px", top: "9px"});

        let mouse = new SMap.Control.Mouse(SMap.MOUSE_PAN | SMap.MOUSE_WHEEL | SMap.MOUSE_ZOOM);
        task_map.addControl(mouse);

        let taks_map_layer = new SMap.Layer.Marker();
        task_map.addLayer(taks_map_layer).enable();

        let taks_mark = new SMap.Marker(center);
        taks_map_layer.addMarker(taks_mark);
    }

    ///////////////////////////////////////////////////////////////////////////////////////////////
    const btn = document.getElementById("logout_submit")

    btn.addEventListener("click", async (e) => {
        e.preventDefault()
        let url = window.location.origin + "/api/logout"
        const api_response = await fetch(url, {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: "{}",
        });
        console.log(await api_response.json())
        window.location.assign(window.location.origin)
    });


    $('input[id="daterange"]').daterangepicker({
        drops: "down",
        opens: "center",
        locale: {
          cancelLabel: 'Clear'
        },
    });
    $('input[id="daterange"]').on('cancel.daterangepicker', function(ev, picker) {
        $(this).val('');
    });
    $('input[id="daterange"]').trigger("cancel.daterangepicker");


    $('input[name="duration"]').daterangepicker({
        drops: "down",
        opens: "center",
        parentEl: "#addNewNoticeModal",
        autoUpdateInput: false,
        locale: {
          cancelLabel: 'Clear'
        },
        minDate: moment().format('MM-DD-YYYY')
    });
    $('input[name="duration"]').on('apply.daterangepicker', function(ev, picker) {
        $(this).val(picker.startDate.format('MM/DD/YYYY') + ' - ' + picker.endDate.format('MM/DD/YYYY'));
    });
    $('input[name="duration"]').on('cancel.daterangepicker', function(ev, picker) {
        $(this).val('');
    });
});


async function get_tickets() {
    const response = await fetch(window.location.origin + "/api/get_tickets");
    return await response.json()
}

function bootstrap_alert_macro(message, type) {
    return `
<div class="alert alert-${type} alert-dismissible fade show" role="alert">
    ${message}
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
</div>
    `
}

function notice_card_macro(notice) {
    return `
<div class="card mt-2">
    <div class="card-header">
        <div class="row">
            <div class="col-12">
                <div class="d-flex">
                    <b class="me-auto" id="card-notice-title-${notice.id}">${notice.title}</b>
                </div>
                <div class="d-flex mt-2">
                    <p class="my-0 me-auto" id="card-notice-duration-${notice.id}">From: ${notice.start_date}, To: ${notice.end_date}</p>
                </div>
            </div>
        </div>
    </div>
    <div class="card-body">
        <p class="card-text" id="card-notice-description-${notice.id}">${notice.description}</p>
    </div>
</div> 
`
}

function manager_notice_card_macro(notice) {
    return `
<div class="card mt-2">
    <div class="card-header">
        <div class="row">
            <div class="col-12">
                <div class="d-flex">
                    <b class="me-auto" id="card-notice-title-${notice.id}">${notice.title}</b>
                    <btn class="btn btn-outline-danger btn-sm delete-button py-0 ms-2" id="del-btn-${notice.id}" 
                         data-bs-toggle="modal" data-bs-target="#delete-notice-modal-${notice.id}">
                        <i class="las la-trash"></i> Delete
                    </btn>
                </div>
                <div class="d-flex mt-2">
                    <p class="my-0 me-auto" id="card-notice-duration-${notice.id}">From: ${notice.start_date}, To: ${notice.end_date}</p>
                    <btn class="btn btn-outline-primary btn-sm edit-button py-0 px-3 ms-2" id="edit-btn-${notice.id}"
                         data-bs-toggle="modal" data-bs-target="#edit-notice-modal-${notice.id}">
                        <i class="las la-edit"></i> Edit
                    </btn>
                </div>
            </div>
        </div>
    </div>
    <div class="card-body">
        <p class="card-text" id="card-notice-description-${notice.id}">${notice.description}</p>
    </div>
</div>
<div class="modal fade" id="delete-notice-modal-${notice.id}" tabindex="-1" aria-labelledby="deleteNoticeModalLabel" aria-hidden="true" style="z-index: 999999999;">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header" style="border-bottom: none; padding-bottom: 0px">
                <h1 class="modal-title fs-5">Are you sure you want to delete this notice?</h1>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body py-0">
                <hr>
            </div>
            <div class="modal-footer" style="border-top: none; padding-top: 0px;">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                <button data-notice-id="${notice.id}" type="button" class="btn btn-danger delete-notice">Delete</button>
            </div>
        </div>
    </div>
</div>
<div class="modal fade" id="edit-notice-modal-${notice.id}" tabindex="-1" aria-labelledby="editNoticeModalLabel" aria-hidden="true" style="z-index: 999999999;">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h1 class="modal-title fs-5">Edit notice</h1>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body py-0">
                <form id="edit-notice-form-${notice.id}" class="mb-3 mt-md-4" method="POST" novalidate>
                    <div id="csrf_token_error" class="text-danger"></div>
                    <div class="mb-3">
                        <label class="form-label" for="notice-title-${notice.id}">Title</label>
                        <input class="form-control" id="notice-title-${notice.id}" name="notice-title-${notice.id}" required="" type="text" value="${notice.title}">
                        <div id="title-error" class="invalid-feedback"></div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label" for="notice-type-${notice.id}">Type</label>
                        <select class="form-select" id="notice-type-${notice.id}">
                            <option value="Announcement" ${notice.type === "Announcement" ? "selected" : ""}>Announcement</option>
                            <option value="Extraordinarity" ${notice.type === "Extraordinarity" ? "selected" : ""}>Extraordinarity</option>
                            <option value="Maintenance" ${notice.type === "Maintenance" ? "selected" : ""}>Maintenance</option>
                            <option value="Closure" ${notice.type === "Closure" ? "selected" : ""}>Closure</option>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label class="text" for="notice-duration-${notice.id}">Duration</label>
                        <input type="text" class="form-control notice-duration" name="notice-duration-${notice.id}" 
                               id="notice-duration-${notice.id}" value="${notice.start_date + " - " + notice.end_date}">
                        <div id="duration-error" class="invalid-feedback"></div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label" for="notice-description-${notice.id}">Description</label>
                        <textarea class="form-control" id="notice-description-${notice.id}" name="notice-description-${notice.id}" required="">${notice.description}</textarea>
                        <div id="description-error" class="invalid-feedback"></div>
                    </div>
                </form>
                <div class="d-grid mt-5">
                    <button class="btn btn-primary edit-notice" style="background-color: #96031A; border-color: #96031A;"
                        data-notice-id="${notice.id}">
                        <i class="las la-save"></i> Save edits
                    </button>
                </div>
                <div id="edit-notice-alerts-${notice.id}" class="mt-3"></div>
                <div id="edit-notice-success-message-${notice.id}" style="display: none;"></div>
            </div>
        </div>
    </div>
</div>
`
}
// <span class="badge bg-secondary">${notice.type}</span><br>