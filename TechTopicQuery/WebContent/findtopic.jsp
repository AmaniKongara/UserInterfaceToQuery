<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page import="java.sql.*" %>
<HTML>
    <HEAD>
    </HEAD>
    <body bgcolor=skyblue>
<h3> Topics from Textbook </h3>
<%
Class.forName("com.mysql.jdbc.Driver");
String connectionURL = "jdbc:mysql://localhost:3306/wikipedia";
Connection connection = null;
Statement statement = null;
Statement statement1 = null;
connection = DriverManager.getConnection(connectionURL, "root", "amanis");
System.out.println("Done!!");
statement = connection.createStatement();
statement1 = connection.createStatement();
	ResultSet rs=null;
    ResultSet rs1=null;
	try
	{
		 String topic=request.getParameter("topic");
		 topic = topic.replace("'","");
		String cmd="Select topic from booktaxonomy where parent like '%"+topic+"%';";%>
          Child Topics:
	  <%  rs =statement.executeQuery(cmd);
	       while(rs.next()){
		     String str=rs.getString(1);
		     String str1 ="htmledition//"+ str +".html"; %>
	          <ul><li><a href="<%=str1%>"><%=str%></a> 
		  <%
		  String cmd1="Select topic from booktaxonomy where parent like'%"+rs.getString(1)+"%';";
		  rs1 = statement1.executeQuery(cmd1);
		  while(rs1.next()){
		  String tf = rs1.getString(1);
		 String ctf = "htmledition//" + tf + ".html";%>
		    <ul> <li><a href="<%=ctf%>"><%=tf %></a></li></ul> 
		 <%}%>
          </li> </ul> 
		 <%}
           rs.close();
	    	String cmds="Select parent from booktaxonomy where topic like '%"+topic+"%';"; %>
            Parent Topics:
	    <%	rs =statement.executeQuery(cmds);
            while(rs.next())
			   {
			     String tf=rs.getString(1);
			    String tf1 = "htmledition//" + tf + ".html";%>
		         <ul><li><a href = "<%=tf1%>"><%=tf%> </a>
	 		  <%String cmd1="Select parent from booktaxonomy where topic like '%"+rs.getString(1)+"%';";
	 		  rs1 = statement1.executeQuery(cmd1);
	 		  while(rs1.next()){
	 		  String t = rs1.getString(1);
	 		  String t1 = "htmledition//" + t + ".html";%>
	 		   <ul><li><a href="<%=t1%>"><%=t %></a></li> </ul>
	 		 <%}%>
	 		 </li> </ul>
	    	<% }
            rs.close();
            statement.close();
	}
	catch(Exception e)
		{
		out.println(e);
		}%>
</body>
</HTML>