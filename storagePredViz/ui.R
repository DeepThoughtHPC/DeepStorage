

# Define UI for dataset viewer application
shinyUI(
  dashboardPage(title = "Flinders University Storage",
    dashboardHeader(title = logo_grey_light, titleWidth = 300),
    dashboardSidebar(
      collapsed = T,
      width = 200,
      
      ## -----------------------------------
      #  Sidebar Menu config
      ## -----------------------------------
      
      sidebarMenu(
        menuItem("History", icon = icon("layer-group"), tabName = "menu_top"),
        menuItem("Forcast", icon = icon("eye"), tabName = "menu_forecast"),
        menuItem("Finance", icon = icon("hand-holding-usd"), tabName = "menu_finance"),
        menuItem("Github", icon = icon("github"), href = "https://github.com/DeepThoughtHPC/DeepStorage"),
        menuItem("RStudio Cloud", icon = icon("cloud"), href = "https://rstudio.cloud/"),
        menuItem("shinyapps.io", icon = icon("external-link-square-alt"), href = "https://okiyuki.shinyapps.io/ShinyAB"),
        menuItem("About", icon = icon("question-circle"), tabName = "menu_about")
      )
    ),
  
    ## -----------------------------------
    #  DashBoard - Main
    ## -----------------------------------
    
    dashboardBody(
      theme_grey_light,
      tabItems(

        
        ## -----------------------------------
        #  DashBoard - History Tab
        ## -----------------------------------
        
        tabItem(tabName = "menu_top",
          fluidRow(
            box(title = "Parameters", width = 12, solidHeader = T, status = "primary",
              fluidRow(
                column(4, 

                     p(HTML("<b>Time Frame</b>"),span(shiny::icon("info-circle"), id = "info_tf"), dateRangeInput('tf', NULL, start = "2019-09-01")),
                       tippy::tippy_this(elementId = "info_tf",tooltip = "define the time frame for visulization",placement = "right")
                     )
                ),
                column(2,
                     p(HTML("<b>Accuracy</b>"),span(shiny::icon("info-circle"), id = "info_acc"), selectInput('acc', NULL, c("Daily", "Weekly", "Monthly", "Quaterly", "Annually")),
                       tippy::tippy_this(elementId = "info_acc",tooltip = "define granulality for visulization'",placement = "right")
                     )
                )
            ),
        
          box(title = "Model Trainer", width = 6, solidHeader = T, status = "primary",
            column(3, 
               p(HTML("<b>New Files</b>"),span(shiny::icon("info-circle"), id = "info_file"), fileInput('file', NULL, buttonLabel = "Choose File")),
                  tippy::tippy_this(elementId = "info_file",tooltip = "choose custom time series data",placement = "right")
            ),
            # fluidRow(
            #   column(6, numericInput('lift', "Lift (%)", 5, min = 0.01, max = 999, step = 0.01)),
            #   column(6, actionButton("btn_cal", "Update 'To Be'"))
            # ),
            # column(12, hr()),
            # fluidRow(
            #   column(6, numericInput('number_of_comparison', "Number of Comparison", 1, step = 1)),
            #   column(6, actionButton("btn_com", "Update 'α'"))
            #)
            
            column(3,
                   p(HTML("<b>Algorithms</b>"),span(shiny::icon("info-circle"), id = "info_acc"), 
                     radioButtons('acc', "Prediction Algorithms", c("ARIMA", "LSTM", "LSTM-DNN")),
                     tippy::tippy_this(elementId = "info_acc",tooltip = "select of prediction algorithms here",placement = "right")
                   )
            ),
            
            column(6, 
                   p(HTML("<b>Start Actions</b>"), span(shiny::icon("info-circle"), id = "info_act"), 
                     submitButton("Start Model Training"),
                     tippy::tippy_this(elementId = "info_act",tooltip = "submit the selected parameters and start model training",placement = "right")
                   )
            ),
            
          ),
        ),
        
          tabBox(
            title = "Hist", width = 6,
            id = "dataPlot",
            tabPanel("HistoryScatter", plotOutput("historyscatter") %>% withSpinner(type = 5)),
            tabPanel("Historystream", plotlyOutput("historystream") %>% withSpinner(type = 5)),
            tabPanel("Historyrange", plotlyOutput("historyrange") %>% withSpinner(type = 5)),
          ),
        
          tabBox(title = "PCA", width = 6, 
                 id = "HisPCA",
                 tabPanel("PCAseason", plotOutput("historyseason") %>% withSpinner(type = 5)),
                 tabPanel("PCAtrend", plotOutput("historytrend") %>% withSpinner(type = 5)),
                 tabPanel("PCArandom", plotOutput("historyrandom") %>% withSpinner(type = 5)),
          )
        ),
      
      
        ## -----------------------------------
        #  DashBoard - About 
        ## -----------------------------------
        tabItem(tabName = "menu_about",
              includeMarkdown("docs/about.md")
        ),
      
        ## -----------------------------------
        #  DashBoard - Prediction Tab
        ## -----------------------------------
    
        tabItem(tabName = "menu_forecast",
          fluidRow(
            box(title = "Forcasting Parameters", width = 12, solidHeader = T, status = "primary",
              fluidRow(
                column(4, 
                       p(HTML("<b>Time Frame</b>"),span(shiny::icon("info-circle"), id = "info_tf"), sliderInput('tf', "Number of forcasting quaters", min = 2, max = 20, 4)),
                         tippy::tippy_this(elementId = "info_tf",tooltip = "define the time frame for visulization",placement = "right")
                )
              ),
              column(4,
                  p(HTML("<b>Algorithms</b>"),span(shiny::icon("info-circle"), id = "info_acc"), 
                    radioButtons('acc', "Prediction Algorithms", c("ARIMA", "LSTM", "LSTM-DNN")),
                    tippy::tippy_this(elementId = "info_acc",tooltip = "select of prediction algorithms here",placement = "right")
                  )
              ),
              column(5, 
                  p(HTML("<b>Start Actions</b>"), span(shiny::icon("info-circle"), id = "info_act"), 
                    submitButton("Start Analysis"),
                    tippy::tippy_this(elementId = "info_act",tooltip = "submit the selected parameters and start the analysis",placement = "right")
                  )
              ),
            ),
            
            ## ------------------
            #   Prediction Plots
            ## ------------------
            
            box(title = "Future Usage", width = 12,
                id = "fig-pred",
                tabPanel("Usage", plotOutput("pred_plot") %>% withSpinner(type = 5))
            ) 
          ),
        ),
      
      
        ## -----------------------------------
        #  DashBoard - Finance Tab
        ## -----------------------------------
      
        tabItem(tabName = "menu_finance",
               includeMarkdown("docs/about.md")
        )
      )
    )
 )
)