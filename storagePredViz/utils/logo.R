#Ref: https://github.com/nik01010/dashboardthemes/blob/master/R/dashboardthemes.R
shinyDashboardLogoDIY <- function(boldText, mainText, textSize = 15, badgeText, badgeTextColor,
                                  badgeTextSize = 2, badgeBackColor, badgeBorderRadius = 3) {
  
  htmltools::HTML(
    
    paste0(
      
      "<p style=\"font-size:", textSize, "px\">
      <b> ", boldText, " </b>",
      
      mainText ,"<span> &nbsp; </span>
      <span style=\"background-color: ", badgeBackColor, ";
      border-radius: ", badgeBorderRadius ,"px; \"> &nbsp;
      <font color=\"", badgeTextColor, "\" size=\"", badgeTextSize, "\">",
      
      badgeText ,"  </font> &nbsp; </span> </p>"
      
    )
    
  )
  
}

logo_grey_light <- shinyDashboardLogoDIY(
  boldText = "Flinders Storage and Planning"
  ,mainText = ""
  ,textSize = 12
  ,badgeText = "0.1.0"
  ,badgeTextColor = "white"
  ,badgeTextSize = 2
  ,badgeBackColor = "rgb(150,150,150)"
  ,badgeBorderRadius = 4
)