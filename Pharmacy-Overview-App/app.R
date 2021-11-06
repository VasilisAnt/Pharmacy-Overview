library(shiny)
library(shinydashboard)
library(shinythemes)
library(dplyr)
library(lubridate)
library(DT)
library(scales)

ui <- dashboardPage(
    
    dashboardHeader(
        title="My Pharmacy"
    ), #End of dashboardHeader
    
    dashboardSidebar(
        sidebarMenu(
            menuItem("Overview",tabName="numbers",icon=icon(name="dashboard")),
            menuItem("Covid-19",tabName="vaccines",icon=icon(name="syringe")),
            menuItem("Prescriptions",tabName="prescriptions_of_month",icon=icon(name="prescription")),
            menuItem("Doctor's Contribution",tabName="Doctors_contribution",icon=icon(name="table")),
            menuItem("Sales",tabName="sales",icon=icon(name="salesforce"))
        ),
        dateRangeInput("date","Date",start=min(all_prescriptions$dates),end=max(all_prescriptions$dates))
    ), #End of dashboardSidebar
    
    dashboardBody(
        
        tabItems(
            #First tab content 
            tabItem(tabName="numbers",
                    fluidRow(
                        infoBoxOutput("number_of_prescriptions"),
                        infoBoxOutput("mean_age"),
                        infoBoxOutput("median_age"),
                        infoBoxOutput("unique_patients")
                    ),#End of fluidRow
                    fluidRow(
                        box(
                            title="Patients with highest out-of-pocket",
                            DT::DTOutput("symmetoxes")
                        ),
                        box(
                            title="Patients with highest compensation from eoppyy",
                            DT::DTOutput("eopyy")
                        )
                    ) #End of fluidRow
            ), #End of first tab content
            
            #Second tab content
            tabItem(tabName="vaccines",
                    fluidRow(
                        box(
                            title="Vaccine candidates",
                            sliderInput("age","Select Age:",min=0,max=99,value=c(40,50)),
                            width=10,
                            DT::DTOutput("covid")
                        )
                    )  #End of fluidRow
            ), #End of second tab content
            
            # Third tab content
            tabItem(tabName="prescriptions_of_month", 
                    fluidRow(
                        box(
                            title="Prescriptions of Month",
                            width=12,
                            DT::DTOutput("table")
                        ) 
                    ), # End of fluidRow
                    fluidRow(
                        box(
                            title="weekdays",
                            plotOutput("plot_days")
                        )
                    ) # End of fluidRow
            ), #End of third tab item
            
            # Fourth tab content
            tabItem(tabName="Doctors_contribution",
                    fluidRow(
                        box(
                            title="Prescription's cost by doctor",
                            plotOutput("doctors")),
                        box(
                            title="Number of prescriptions per doctor",
                            plotOutput("doctors_prescriptions")
                        ),
                        box(
                            title="Doctor's Contribution per month",
                            width=12,
                            plotOutput("doctors_contribution")
                        ),
                        box(
                            title="Doctor's Average per date selected",
                            selectizeInput("name_of_doctor","Select Name of Doctor:",choices=NULL,multiple=TRUE),
                            plotOutput("doctors_average")
                        )
                    ) #End of fluidRow
            ), #End of fourth tab item
            
            # Fifth tab content
            tabItem(tabName="sales",
                    fluidRow(
                        box(
                            title="Farmaka",
                            plotOutput("farmaka")
                        ),
                        box(
                            title="Parafarmaka",
                            plotOutput("parafarmaka")
                        ),
                        box(
                            title="Analosima",
                            plotOutput("analosima")
                        ),
                        box(
                            title="OTC",
                            plotOutput("otc")
                        ),
                        box(
                            title="OTC 2",
                            width=12,
                            plotOutput("otc2")
                        )
                    ), # End of fluidRow
                    
                    fluidRow(
                        box(
                            title="OTC 3",
                            plotOutput("otc3")
                        ),
                        box(
                            title="OTC 4 (change column refers to previous year's pieces)",
                            DT::DTOutput("otc4")
                        )
                    ), # End of fluidRow
            ), # End of fifth tab item
            
            
            # Sixth tab content
            
            tabItem(tabName="profit-costs",
                    fluidRow(
                        box(
                            title="Sales",
                            plotOutput("tziros")
                        )
                    ) # End of fluidRow
            ) # End of sixth tab content
            
            
            
            
        ) #End of tabItems  
    ) #End of dashboardBody
    
    
    
) #End of dashboardPage



server <- function(input,output,session){
    
    #Reactive filter for prescriptions
    prescriptions_all <- reactive({
        all_prescriptions%>%
            filter(dates>=input$date[1] & dates<=input$date[2])
    })
    
    #Table about out-of-pockets (symmetoxes)
    output$symmetoxes <- DT::renderDT({
        
        prescriptions_all()%>%
            group_by(Patient)%>%
            summarize(Out_of_pocket_in_euros=sum(price_of_patients))%>%
            arrange(desc(Out_of_pocket_in_euros))
        
    })
    #Table about compensation from eopyy
    output$eopyy <- DT::renderDT({
        
        prescriptions_all()%>%
            group_by(Patient)%>%
            summarize(Total_eoppy_in_euros=sum(price_of_eoppy))%>%
            arrange(desc(Total_eoppy_in_euros))
        
    })
    #Table for prescriptions selected
    
    output$table <- DT::renderDT({
        prescriptions_all()%>%
            select(-AMKA_patient,-AMKA_doctor,YOB)
        
    })
    #Table for number of prescrptions executed per day
    output$plot_days <- renderPlot({
        prescriptions_all()%>%
            count(Day,sort=TRUE)%>%
            ggplot(aes(x=fct_reorder(Day,n),y=n))+
            geom_col(fill="darkorchid3")+
            coord_flip()+
            labs(x="",y="Number of prescriptions")
        #scale_y_continuous(breaks=c(0,50,100,150,200,250,300),limits=c(0,300))
    })
    
    #Table for doctor's prescription cost
    output$doctors <- renderPlot({
        
        
        
        prescriptions_all()%>%
            add_count(Doctor,name="Prescriptions")%>%
            mutate(Doctor= glue("{Doctor} ({ Prescriptions })"))%>%
            group_by(Doctor)%>%
            summarize(Total=sum(total_price))%>%
            arrange(desc(Total))%>%
            head(15)%>%
            ggplot(aes(x=fct_reorder(Doctor,Total),y=Total, fill = Doctor))+
            geom_col()+
            scale_fill_brewer(palette="Spectral")+
            coord_flip()+
            labs(x="",y="")+
            scale_y_continuous(labels = dollar_format(suffix="€",prefix=""),breaks=breaks_extended(8))+
            theme(panel.grid.minor.x=element_blank())
        
        
    })
    
    #Plot for doctors number of prescriptions
    
    output$doctors_prescriptions <- renderPlot ({
        
        prescriptions_all()%>%
            count(Doctor,sort=TRUE)%>%
            head(15)%>%
            ggplot(aes(x=fct_reorder(Doctor,n),y=n))+
            geom_col(fill="#6DA0FD")+
            coord_flip()+
            labs(x="",y="")+
            scale_y_continuous(breaks=breaks_extended(8))+
            theme(panel.grid.minor.x=element_blank())
        
    })
    #Plot for doctors average per date
    
    updateSelectizeInput(
        session, "name_of_doctor", choices = doctors_with_highest_total, server = TRUE,selected=doctors_with_five_highest_total)
    
    output$doctors_average <- renderPlot ({
        
        prescriptions_all()%>%
            filter(Doctor %in% doctors_with_highest_total)%>%
            filter(Doctor==input$name_of_doctor)%>%
            group_by(Year, Month, Doctor)%>%
            summarize(Average_per_month=mean(total_price))%>%
            ungroup()%>%
            mutate(Date=str_c(Year,Month,"01",sep="-"),
                   Date=ymd(Date))%>%
            ggplot(aes(x=Date,y=Average_per_month,color=Doctor,group=Doctor))+
            geom_line()+
            labs(y="Average")+
            scale_x_date(date_breaks="1 month",date_labels="%b %y")+
            scale_y_continuous(labels = dollar_format(suffix="\u20ac",prefix=""),breaks=seq(0,100,by=10))
        
        
    })
    
    
    # Plot for doctors contribution to the pharmacy per month
    
    output$doctors_contribution <- renderPlot ({
        
        prescriptions_all()%>%
            mutate(Year=year(dates))%>%
            select(Year,everything())%>%
            filter(Doctor %in% doctors_with_highest_total)%>%
            group_by(Year,Month,Doctor)%>%
            summarize(total=sum(total_price))%>%
            ungroup()%>%
            mutate(Date=str_c(Year,Month,"01",sep="-"),
                   Date=ymd(Date))%>%
            ggplot(aes(x=Date,y=total,color=Doctor,group=Doctor))+
            geom_point()+
            geom_line()+
            scale_x_date(date_breaks="1 month",date_labels="%b %y")+
            scale_y_continuous(labels = dollar_format(suffix="\u20ac",prefix=""))+
            facet_wrap(~Doctor)+
            labs(x="",
                 y="")+
            guides(colour=FALSE)
        
    })
    
    # Plot for tziros
    
    output$tziros <- renderPlot ({
        
        tziros_without_fpa%>%
            filter(Year %in% c(2020))%>%
            group_by(Year)%>%
            summarize(total_per_year=sum(Total))%>%
            mutate(total_per_year=round(total_per_year,digits=0),
                   End=lag(total_per_year),
                   xpos=1:n()-0.5,
                   Diff=total_per_year-End,
                   Percent=paste(round(Diff/End*100,2),"%"),
                   Year=as.factor(Year))%>%
            ggplot(aes(x=Year,y=total_per_year,fill=Year))+
            geom_col(width = 0.6)+
            stat_summary(aes(label=scales::comma(..y..)),fun="sum",geom="text",col="black",vjust=0.01)+
            geom_segment(aes(x=xpos,y=End,xend=xpos,yend=total_per_year))+
            geom_text(aes(x=xpos,y=End-Diff/2,label=Percent),size=3.5)+
            scale_y_continuous(labels = dollar_format(suffix="\u20ac",prefix=""))+
            theme(legend.position = "none",
                  panel.grid.major.x = element_blank(),
                  axis.ticks=element_blank())+
            labs(x="",
                 y="")
        
        
        
    })
    
    
    
    # Plot for farmaka
    
    output$farmaka <- renderPlot ({
        
        tziros_without_fpa%>%
            ggplot(aes(x=Month,y=Farmaka,color=Year,group=Year))+
            geom_line()+
            geom_point()+
            scale_y_continuous(labels = dollar_format(suffix="\u20ac",prefix=""),limits=c(20000,35000))+
            labs(x="",
                 y="")+
            theme_light()
        
    })
    
    
    # Plot for parafarmaka
    output$parafarmaka <- renderPlot ({
        
        tziros_without_fpa%>%
            ggplot(aes(x=Month,y=Parafarmaka,color=Year,group=Year))+
            geom_line()+
            geom_point()+
            scale_y_continuous(labels = dollar_format(suffix="\u20ac",prefix=""))+
            labs(x="",
                 y="")+
            theme_light()
        
    })
    
    
    
    # Plot for analosima
    
    
    output$analosima <- renderPlot ({
        
        tziros_without_fpa%>%
            ggplot(aes(x=Month,y=Analosima,color=Year,group=Year))+
            geom_line()+
            geom_point()+
            scale_y_continuous(labels = dollar_format(suffix="\u20ac",prefix=""),limits=c(100,1100),breaks=c(300,500,700,900,1100))+
            labs(x="",
                 y="")+
            theme_light()
    })
    
    # Plot for OTC
    
    output$otc <- renderPlot({
        
        OTC_profit%>%
            ggplot(aes(x=fct_reorder(str_to_title(Drug),Total_profit),y=Total_profit,fill=Drug))+
            geom_col()+
            coord_flip()+
            scale_y_continuous(breaks=seq(0,2500,by=500))+
            labs(y="Net profit",x="",
                 title="30 most profitable OTCs",
                 subtitle="For period 01/2017-04/2021")+
            theme(axis.ticks=element_blank(),
                  legend.position="none")+
            scale_y_continuous(labels = dollar_format(suffix="\u20ac",prefix=""))
        
        
    })
    
    # Plot for OTC, thirty most profitable, ongoing analysis in quantities
    
    output$otc2 <- renderPlot({
        
        
        OTC_automated_profit%>%
            filter(Month %in% c("Jan","Feb","Mar","Apr","May","Jun","Jul"))%>%
            group_by(Drug,Year)%>%
            summarize(total=sum(Quantity))%>%
            ungroup()%>%
            filter(Drug %in% thirty_most_profitable)%>%
            filter(Year %in% c(2020,2021))%>%
            ggplot(aes(x=Year,y=total,group=Drug,color=Year))+
            geom_line()+
            geom_point()+
            facet_wrap(~Drug,ncol=5,scale="free_y")+
            theme(legend.position="bottom",
                  axis.text.x=element_blank(),
                  axis.ticks=element_blank())+
            labs(x="",
                 y="pieces",
                 subtitle="pieces sold for the first 4 months of the year\n (30 most profitable OTCs)")
        
    })
    
    ##Change of OTC quantities between 2020 and 2021 of 30 most profitable products (over 1/2017-08/2021) plot
    
    output$otc3 <- renderPlot({
        
        OTC_automated_profit%>%
            filter(Month %in% c("Jan","Feb","Mar","Apr", "May", "Jun", "Jul"))%>%
            group_by(Drug,Year)%>%
            summarize(Total=sum(Quantity,na.rm=TRUE))%>%
            filter(Year %in% c(2020,2021))%>%
            mutate(Change=Total-lag(Total,default=0))%>%
            filter(Year %in% c(2021),Change!=0)%>%
            filter(Drug %in% thirty_most_profitable)%>%
            ungroup()%>%
            mutate(positive=ifelse(Change>0,TRUE,FALSE),
                   Drug=str_to_title(Drug))%>%
            arrange(desc(Change))%>%
            ggplot(aes(x=fct_reorder(Drug,Change),y=Change,fill=positive))+
            geom_col()+
            geom_text(aes(label=Change),color="black",size=2.6,hjust=1)+
            coord_flip()+
            scale_fill_brewer(palette="Pastel1")+
            theme(legend.position="none")+
            scale_y_continuous(limits=c(-150,150),breaks=c(-150,-100,-50,0,50,100,150))+
            labs(x="",
                 y="Change",
                 subtitle = "change in pieces for the first 4 months of 2021 compared to\n 2020\n (30 most profitable OTCs)")
        
    })
    
    ##Change of OTC quantities between 2020 and 2021 of 30 most profitable products (over 1/2017-08/2021) table
    
    
    output$otc4 <- DT::renderDT ({
        
        OTC_automated_profit%>%
            filter(Month %in% c("Jan","Feb","Mar", "Apr", "May", "Jun", "Jul"))%>%
            group_by(Drug,Year)%>%
            summarize(Total=sum(Quantity,na.rm=TRUE))%>%
            ungroup()%>%
            mutate(Change=Total-lag(Total,default=0),
                   Sign=if_else(Change>0,"POSITIVE","NEGATIVE"))%>%
            filter(Year %in% c("2021"))%>%
            mutate(Sign=as.factor(Sign))
        
    })
    
    # Covid-19 vaccinations filter
    
    output$covid <- DT::renderDT({
        
        all_prescriptions%>%
            filter(Age>=input$age[1] & Age<=input$age[2])%>%
            distinct(AMKA_patient,.keep_all = TRUE)%>%
            select(AMKA_patient,Patient,Age)%>%
            mutate(DOF=str_sub(AMKA_patient,start=1,end=6))%>%
            mutate(day=str_sub(DOF,start=1,end=2),
                   month=str_sub(DOF,start=3,end=4),
                   year=str_sub(DOF,start=5,end=6))%>%
            mutate(year=paste0("19",year),
                   dob=paste(day,month,year,sep="-"),
                   dob=dmy(dob))%>%
            select(AMKA_patient,Patient,dob)%>%
            mutate(today=today())%>%
            mutate(time_difference_in_days=difftime(today,dob),
                   time_difference_in_years=time_length(time_difference_in_days,"years"))%>%
            #filter(time_difference_in_years>84)%>%
            arrange(time_difference_in_years)
        
        
    })
    
    
    
    
    
    
    
    #Info box for number of prescriptions
    
    output$number_of_prescriptions <- renderInfoBox({
        
        x <-  prescriptions_all()%>%
            nrow()
        infoBox(value=x,title="Number of prescriptions",color="aqua")
        
    })
    
    #Info box for mean_age of patients
    
    output$mean_age<- renderInfoBox({
        
        y <- prescriptions_all()%>%
            summarize(Mean_Age=round(mean(Age),digits=1))%>%
            pull()
        infoBox(title="Mean Age",value=y,color="green")
        
    })
    
    
    #Infobox for median age of patients
    
    output$median_age <- renderInfoBox({
        
        z <- prescriptions_all()%>%
            summarize(Median_Age=median(Age))%>%
            pull()
        infoBox(title="Median Age",value=z,color="yellow")
        
    })
    
    #Infobox for unique patients
    
    output$unique_patients <- renderInfoBox({
        
        i <- prescriptions_all()%>%
            distinct(AMKA_patient)%>%
            nrow()
        infoBox(title="Number of different patients",value=i,color="purple")
        
    })
    
    
}  


shinyApp(ui,server)






