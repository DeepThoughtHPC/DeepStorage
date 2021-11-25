

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
        menuItem("Finance", icon = icon("hand-holding-usd"), tabName = "menu_finance", selected = TRUE),
        menuItem("Github", icon = icon("github"), href = "https://github.com/DeepThoughtHPC/DeepStorage"),
        menuItem("RStudio Cloud", icon = icon("cloud"), href = "https://rstudio.cloud/"),
        menuItem("shinyapps.io", icon = icon("external-link-square-alt"), href = "https://okiyuki.shinyapps.io/ShinyAB"),
        menuItem("Documentation", icon = icon("file"), tabName = "menu_doc"),
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
        #  DashBoard - Docu
        ## -----------------------------------
        
        tabItem(tabName = "menu_doc",
                includeMarkdown("docs/docu.md")
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
                    radioButtons('acc', "Prediction Algorithms:", c("ARIMA", "LSTM", "LSTM-DNN")),
                    tippy::tippy_this(elementId = "info_acc",tooltip = "select of prediction algorithms here",placement = "right")
                  )
              ),
              column(4,
                     p(HTML("<b>Options</b>"),span(shiny::icon("info-circle"), id = "info_acc"), 
                       radioButtons('acc', "Update Options:", c("Rolling updates", "Step updates")),
                       tippy::tippy_this(elementId = "info_acc",tooltip = "select more granular options for predictions",placement = "right")
                     )
              ),
              column(4,
                fluidRow(
                  p(HTML("<b>Start Actions</b>"), span(shiny::icon("info-circle"), id = "info_act"), 
                    submitButton("Start Analysis"),
                    tippy::tippy_this(elementId = "info_act",tooltip = "submit the selected parameters and start the analysis",placement = "right")
                  )
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
          fluidRow(
            box(title = "Financial Parameters", width = 12, solidHeader = T, status = "primary",
              fluidRow(
                column(2, numericInput('nu_int', "Interest Rate in %", 2.5, min = 0.01, max = 15, step = 0.01)),
                # column(6, actionButton("btn_cal", "Update 'To Be'"))
              ),
              
              box(title = "Purchase Options:", width = 10, soliHeader = T, status ="success",
                fluidRow(
                  column(4, 
                    fluidRow(
                      column(12,
                        p(HTML("<b>Base Cost</b>"),span(shiny::icon("info-circle"), id = "info_base"), 
                          numericInput('nu_base', NULL, 2, step = 1),
                          tippy::tippy_this(elementId = "info_base",tooltip = "Base Cost in $1K unit",placement = "right")                         
                        )
                      )
                    ),
                    fluidRow(
                      column(12,
                        p(HTML("<b>No.Senario</b>"),span(shiny::icon("info-circle"), id = "info_sena"), 
                           numericInput('nu_sena', NULL, 2, step = 1),
                           tippy::tippy_this(elementId = "info_sena",tooltip = "Number of senario is intended to analysis as a cluster",placement = "right")
                        )
                      )
                    )
                  ),
                  column(3,
                    p(HTML("<b>No.Steps</b>"),span(shiny::icon("info-circle"), id = "info_step"), 
                           numericInput('nu_step', NULL, 2, step = 1, min = 1, max = 12)),
                           tippy::tippy_this(elementId = "info_step",tooltip = "Number of procurement in one year",placement = "right")
                  ),                
                  column(3, 
                      fluidRow(
                        p(HTML("<b>Update: </b>"),span(shiny::icon("info-circle"), id = "info_fin_update_2"),     
                          actionButton("update_fin_param", "Register Parameters", icon = icon("cash-register"), class = "btn-update"),
                          tippy::tippy_this(elementId = "info_fin_update_2",tooltip = "To register each set of parameters for financial analysis",placement = "right")
                        )
                      ),
                      fluidRow(
                        p(HTML("<b>Reset/Restart: </b>"),span(shiny::icon("info-circle"), id = "info_acc_2"),     
                          actionButton("reset_fin_param", "Reset parameters", icon = icon("redo"), class = "btn-reset"),
                          tippy::tippy_this(elementId = "info_acc_2",tooltip = "To reset/restart setting parameters for financial senarios",placement = "right")
                        )
                      ),
                  )
                  # column(6, actionButton("btn_com", "Update 'α'"))
                )
              ),
              
              box(title = "Comparison Options:", width = 5, soliHeader = T, status ="success",
                  fluidRow(
                    column(4,
                           p(HTML("<b>Options</b>"),span(shiny::icon("info-circle"), id = "info_acc"), 
                             radioButtons('acc', "Update Options:", c("Individual", "Overlay")),
                             tippy::tippy_this(elementId = "info_acc",tooltip = "select more granular options for predictions",placement = "right")
                           )
                    ),
                  )
              ),
              
              column(4,
                fluidRow(
                  p(HTML("<b>Updates: </b>"), span(shiny::icon("info-circle"), id = "info_fin_update"), 
                    fluidRow(
                      actionButton("update_fin_board_param", "update analysis parameters"),
                    ),
                    tippy::tippy_this(elementId = "info_fin_update",tooltip = "Update the parameters for finance analysis board",placement = "right")
                  )
                ),
                
                fluidRow(
                  p(HTML("<b>Actions: </b>"), span(shiny::icon("info-circle"), id = "info_fin_action"), 
                    submitButton("ANALYSIS", icon = icon("sync")),
                    tippy::tippy_this(elementId = "info_fin_action",tooltip = "submit the selected parameters and start the finance analysis",placement = "right")
                  )
                ),                
              ),
              
            )
          )
        )
        ## -----------------------------------
        #  DashBoard - Finance Tab Finish Here
        ## -----------------------------------
      )
    )
 )
)