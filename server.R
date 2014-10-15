library(shiny)
library(statnet)
library(shinyapps)


shinyServer(function(input, output, session) {

  netInput<- reactive({network.initialize(input$slider1,directed=F)})
  
  targetInput<-reactive({c(input$slider2,input$slider3,input$slider4*input$slider1,input$box1)})  

netrx.sim1Input<-reactive({
  netrx<-netInput()
  netrx %v% 'Org type' <-c(rep(1,8),rep(2,8),rep(3,2),rep(4,2),rep(5,1))
  netrx %v% 'ID' <- c(1:input$slider1) 
  netrx.fit<-ergm(netrx ~density+meandeg+nodematch('Org type')+degree(0),target.stats=targetInput())
  netrx.sim1 <- simulate.ergm(netrx.fit)

})  
output$plot1<-renderPlot({  
  
  node_vector.degree<- degree(netrx.sim1Input(), g=1, nodes=NULL, gmode="graph")
  node_vector.between<-betweenness(netrx.sim1Input(), g=1, nodes=NULL, gmode="graph")
  node_vector.org <- netrx.sim1Input() %v% "Org type"
  node_vector.id <- netrx.sim1Input() %v% "ID"
  
  node_vector.org[node_vector.org==1]<-"blue"
  node_vector.org[node_vector.org==2]<-"black"
  node_vector.org[node_vector.org==3]<-"yellow"
  node_vector.org[node_vector.org==4]<-"red"
  node_vector.org[node_vector.org==5]<-"cyan"
  

  coord <- gplot(netrx.sim1Input(), gmode="graph", vertex.col=node_vector.org, vertex.sides=99, edge.col="grey", 
                 label=node_vector.id, interactive==TRUE)
  legend("bottomleft", legend=c("MoH", "NGO/CSO", "Development partner", "Researcher", "Other"), 
         pch=21, pt.cex=2, pt.bg=c("blue", "black", "yellow", "red", "cyan"))

                       if (input$size == 2){
                         gplot(netrx.sim1Input(), coord=coord, gmode="graph", vertex.col=node_vector.org, 
                         vertex.cex=node_vector.degree/4, vertex.sides=99, edge.col="grey", 
                         label=node_vector.id)
                         legend("bottomleft", legend=c("MoH", "NGO/CSO", "Development partner", "Researcher", "Other"), 
                                pch=21, pt.cex=2, pt.bg=c("blue", "black", "yellow", "red", "cyan"))
                       }
                       if (input$size == 3){
                        gplot(netrx.sim1Input(), coord=coord, gmode="graph",vertex.col=node_vector.org, 
                        vertex.cex=node_vector.between/4, vertex.sides=99, edge.col="grey", 
                        label=node_vector.id)
                        legend("bottomleft", legend=c("MoH", "NGO/CSO", "Development partner", "Researcher", "Other"), 
                               pch=21, pt.cex=2, pt.bg=c("blue", "black", "yellow", "red", "cyan"))
                       }
  })


  observe({
    change<-1.5-3.1*(input$slider2)+0.03*(input$slider3)
    evidence<-1.5-1.5*(input$slider2)-0.08*(input$slider3)
    
    updateSliderInput(session, "result1", 
    label=("Probability of policy change for this network"),
    value = change)
    
    updateSliderInput(session, "result2", 
                      label=("Probability of evidence use in this network"),
                      value = evidence)
    
      })
})
  

