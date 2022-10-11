CREATE PROCEDURE [dbo].[masterTaripPeriodeSelect]
as
Begin
	set nocount on;
Select * from masterTaripPeriode order by tglMulaiBerlaku;
End