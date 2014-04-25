<%@ page import="java.sql.*" %>
<HTML>
    <HEAD>
    </HEAD>
    <body bgcolor=skyblue>
<h3> Topics from Wikipedia Hierarchy </h3>
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
    ResultSet rs2=null;
	try
	{
		 String topic=request.getParameter("wikitopic");%>
         Super categories of the given category: <ul>
		<% String cmds="Select topic from topicdb where child_topic like '%"+topic+"%' and child_type=\"subcat\";";
	    	rs =statement.executeQuery(cmds);
		    while(rs.next())
			   {
			    String str=rs.getString(1);%>
		         <li><%=rs.getString(1)%> </li>
			  <% }%> </ul> Super categories of the given page: <ul>
		<% String newtopic = topic.toUpperCase(); 
		String cmds1 = "Select topic from topicdb where child_topic like'%" +newtopic+"%' and child_type=\"page\";";
		System.out.println(cmds1);
	    	rs2 = statement.executeQuery(cmds1);
		    while(rs2.next())
			   {
			     String str=rs2.getString(1);%>
		         <li><%=rs2.getString(1)%> </li>
			  <% }%> </ul>SubCategories under the given topic: <ul>
	           <%rs2.close();%>
	 		  <%String cmd1="Select child_topic from topicdb where topic like '%"+topic+"%' and child_type=\"subcat\";";
	 		  rs1 = statement1.executeQuery(cmd1);
	 		  while(rs1.next()){%>
	 		    <li><%=rs1.getString(1)%></li> 
	 		 <%}
	 		 rs1.close();%></ul>  Pages under the given topic: <ul>
		<% String cmd="Select child_topic from topicdb where topic like '%"+topic+"%' and child_type=\"page\";";
         rs =statement.executeQuery(cmd);
	       while(rs.next()){
		     String str=rs.getString(1);
		     char first = Character.toUpperCase(str.charAt(0));
		     String s=first + str.substring(1);
		     %>
	          <li><%=rs.getString(1)%> </li>
		  <%}%> </ul> 
		  <%rs.close(); 
	    	 statement.close();
	}
	catch(Exception e)
		{
		out.println(e);
		}%>
</body>
</HTML>