$(() => {
    addHomeListeners()
});

const splashScreenHTML = `
        <div id="welcome-splash">
            <div id="welcome-logo">
                <a id="logo-link" href="/">penda</a>
                <div id="welcome-options">
                    <div class="btn-group" role="group" aria-label="Button group for time entries">
                        <form class="button_to" method="get" action="/businesses/new"><input class="btn choices-btn1" type="submit" value="business user" kl_vkbd_parsed="true"></form>
                        <form class="button_to" method="get" action="/clients/new"><input class="btn choices-btn2" type="submit" value="standard user" kl_vkbd_parsed="true"></form>
                    </div> <!-- btn-group -->
                </div> <!-- .welcome-options -->
            </div> 
        </div>
    `

function addHomeListeners() {
    $('.js-signup').on('click', function (e) {
        e.preventDefault();       
        $('#js-ContentBox').html("");
        $('#js-ContentBox').html(splashScreenHTML);
    });

     //make use of event delegation to capture link
    $('.js-Projects').on('click', 'a', function(e) {
        e.preventDefault();
        loadProject(this);
    }); 

	$('a.js-AllProjects').on('click', function (e) {
        e.preventDefault();
		getProjects();
    });

    $('a.js-ActiveProjects').on('click', function (e) {
        e.preventDefault();
        const params = { "status": "active" }
		getProjects(params);
    });

    $('a.js-CompletedProjects').on('click', function (e) {
        e.preventDefault();
        params = { "status": "completed" }
		getProjects(params);
    });

    window.addEventListener("popstate", function(e) {
        if (window.historyInitiated) {
          window.location.reload();
        }
    });
}

// populate dashboard view list of projects 
function getProjects(query) {
    const url = new URL('https://localhost:3000/dashboard.json'), params = query;
    
    // append params to generated url if a query was made
    if (query !== undefined) {
        Object.keys(params).forEach(key => url.searchParams.append(key, params[key]));
    }
    
    fetch(url)
        .then(response => response.json())
            .then(data => {
                $('.js-Projects').html("");

                // handle query results
                if (data.projects[0] === undefined) {
                    $('.js-Projects').prepend('<span>No results found.</span>');  
                } else {
                    data['projects'].forEach(project => {
                        currentProject = new Project(project);
                        $('.js-Projects').prepend(currentProject.projectsListHTML());
                    });
                }
            });
}

function loadProject(data) {
    fetch(`/projects/${data.dataset.id}.json`)
        .then(response => response.json())
            .then(data => {
                currentProject = new Project(data.project);
                $('.js-Content').html("");
                $('.js-Content').load(`/projects/${currentProject.id}.html .js-Content`);

                //append project path to the URL history
                window.historyInitiated = true;
                history.pushState(null, null, `/projects/${currentProject.id}`);
            });
}