
public class xray {

	public static void main( String[] args) {
		
		for (int i=12595;i<=12618;i++) {
			int z = i - 12595;
System.out.println("        {");
			System.out.println("            \"testKey\" : \"XRAY-"+i+"\",\r\n" + 
					"            \"start\" : \"$($FinalDateStr)\",\r\n" + 
					"            \"finish\" : \"$($FinalDateStr)\",\r\n" + 
					"            \"comment\" : \"Successful execution\",\r\n" + 
					"            \"status\" : \"$($FinalStatus["+z+"])\"");
			System.out.println("        },");			
		}
	}
}
