 #! /usr/local/bin/perl
   
   # instala o net-snmp no linux e libera o acesso no arquivo de configuração do SNMP pros OID colocar o IP da maquina destino 

   use strict;
   use warnings;

   use Net::SNMP;

   #Lista de OID
   my $OID_SOType             = '1.3.6.1.2.1.1.1.0';
   my $OID_sysUpTime          = '1.3.6.1.2.1.1.3.0';
   my $OID_1MinutesCPULoad    = '.1.3.6.1.4.1.2021.10.1.3.1';
   my $OID_5MinutesCPULoad    = '.1.3.6.1.4.1.2021.10.1.3.2';
   my $OID_15MinutesCPULoad   = '.1.3.6.1.4.1.2021.10.1.3.3'; 
   my $OID_TotalSwapMemory    = '.1.3.6.1.4.1.2021.4.3.0';
   my $OID_AvaliableSwapSpace = '.1.3.6.1.4.1.2021.4.4.0';
   my $OID_TotalRamMemory     = '.1.3.6.1.4.1.2021.4.5.0';
   my $OID_UsedRamMemory      = '.1.3.6.1.4.1.2021.4.6.0';
   my $OID_FreeRamMemory      = '.1.3.6.1.4.1.2021.4.11.0';
   my $OID_DiskFreeSpace      = '.1.3.6.1.4.1.2021.9.1.7.1';
   my $OID_DiskTotalSpace     = '.1.3.6.1.4.1.2021.9.1.6.1';

   my ($session, $error) = Net::SNMP->session(
      -hostname  => shift || '10.0.0.46',
      -community => shift || 'public',
   );

   # Pegar descricao do SO
   my $result = $session->get_request(-varbindlist => [ $OID_SOType ],);
   
   printf "A descricao do sistema operacional do host '%s' e: \n%s.\n",
          $session->hostname(), $result->{$OID_SOType};        

   #Pegar Carga da CPU
   $result = $session->get_request(-varbindlist => [ $OID_1MinutesCPULoad ],);
   printf "O uso de CPU no ultimo minuto foi: \n%5.2f.\n",
          $result->{$OID_1MinutesCPULoad} * 100;   
   
   $result = $session->get_request(-varbindlist => [ $OID_5MinutesCPULoad ],);
   printf "O uso de CPU nos ultimos 5 minutos foi: \n%5.2f.\n",
          $result->{$OID_5MinutesCPULoad} * 100; 
   
   $result = $session->get_request(-varbindlist => [ $OID_15MinutesCPULoad ],);
   printf "O uso de CPU nos ultimos 15 minutos foi: \n%5.2f.\n",
          $result->{$OID_15MinutesCPULoad} * 100;   

   #Pegar Dados da Memoria
   $result = $session->get_request(-varbindlist => [ $OID_TotalSwapMemory ],);
   printf "Total de Memoria swap: \n%f GB.\n",
          $result->{$OID_TotalSwapMemory} / 1024 / 1024;   

   $result = $session->get_request(-varbindlist => [ $OID_AvaliableSwapSpace ],);
   printf "Total de Memoria swap disponivel: \n%f GB.\n",
          $result->{$OID_AvaliableSwapSpace} / 1024 / 1024;  

   $result = $session->get_request(-varbindlist => [ $OID_TotalRamMemory],);
   printf "Total de Memoria RAM: \n%f KB.\n",
          $result->{$OID_TotalRamMemory};  
   
   $result = $session->get_request(-varbindlist => [ $OID_UsedRamMemory],);
   printf "Total de Memoria RAM utilizada: \n%f KB.\n",
          $result->{$OID_UsedRamMemory}; 

   $result = $session->get_request(-varbindlist => [ $OID_FreeRamMemory ],);
   printf "Total de Memoria RAM disponível: \n%f KB.\n",
          $result->{$OID_FreeRamMemory};

   #Pegar dados de Disco
   $result = $session->get_request(-varbindlist => [ $OID_DiskTotalSpace ],);
   printf "Tamanho total do disco: \n%f GB.\n",
          $result->{$OID_DiskTotalSpace} / 1024 / 1024;
   $result = $session->get_request(-varbindlist => [ $OID_DiskFreeSpace ],);
   printf "Espaço em disco Disponível disponível: \n%f GB.\n",
          $result->{$OID_DiskFreeSpace} / 1024 / 1024;

   $session->close();

   exit 0;
