library ieee;
use ieee.std_logic_1164.all;

entity Cordic IS
  port(
    clock : in std_logic;
    reset : in std_logic;
    address : in std_logic;
    
    data_in : in std_logic_vector(31 downto 0);
    Z_out: out std_logic_vector(31 downto 0);
    Y_out: out std_logic_vector(31 downto 0);
    X_out: out std_logic_vector(31 downto 0)
    );
  end entity;
  
architecture Cordic of Cordic is

signal Signal : std_logic;
signal Address : std_logic_vector(31 downto 0);
signal Data_Bus : std_logic_vector(35 downto 0);
signal Clock : std_logic;
signal Reset : std_logic;
signal Ack : std_logic;
signal Read : std_logic;

begin








end architecture; 
    