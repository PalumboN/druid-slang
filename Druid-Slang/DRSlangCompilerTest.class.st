Class {
	#name : #DRSlangCompilerTest,
	#superclass : #TestCase,
	#category : #'Druid-Slang'
}

{ #category : #tests }
DRSlangCompilerTest >> test1 [

	| dir file |
	dir := '/Users/palumbon/Documents/Pharo/repos/Slang-example/generated'
		       asFileReference.

	file := dir / 'Pepita.c'.

	DRSlangCompiler exportPackage: #SlangOOPExample asPackage To: file.

	self assert: file contents equals: ('#include <stdio.h>
#include <stdlib.h>

typedef struct {
	int	type;
 } DRSlangTypedStruct;


typedef struct {
	int	type;
	int	energia;
 } Pepita_Slang;


typedef struct {
	int	type;
	int	kms;
 } Pepona_Slang;



/*** Function Prototypes ***/
static int alimentar(DRSlangTypedStruct *arg1);
extern int main(void);
static Pepita_Slang * Pepita_come(Pepita_Slang * self_in_Pepita_come, int arg1);
static int Pepita_estaCansada(Pepita_Slang * self_in_Pepita_estaCansada);
static Pepita_Slang * Pepita_Slang_init(Pepita_Slang * self_in_Pepita_Slang_init);
static Pepona_Slang * Pepona_come(Pepona_Slang * self_in_Pepona_come, int arg1);
static int Pepona_estaCansada(Pepona_Slang * self_in_Pepona_estaCansada);
static Pepona_Slang * Pepona_Slang_init(Pepona_Slang * self_in_Pepona_Slang_init);


/*** Variables ***/

/* Entrenador_Slang>>#alimentar: */
static int
alimentar(DRSlangTypedStruct *arg1)
{
	Pepita_Slang * tmp1;
	Pepona_Slang * tmp2;

	if (((arg1->type)) == 2) {
		tmp1 = Pepita_come(arg1, 5);
		return 1;
	}
	tmp2 = Pepona_come(arg1, 5);
	return 1;
}
/* Entrenador_Slang>>#main */
int
main(void)
{
	Pepita_Slang *tmp1;
	int tmp2;
	int tmp3;
	int tmp4;
	int tmp5;

	tmp1 = Pepita_Slang_init(malloc(sizeof(Pepita_Slang)));
	tmp2 = alimentar(tmp1);
	if (((tmp1->type)) == 2) {
		tmp3 = Pepita_estaCansada(tmp1);
		tmp4 = printf("%d\n", tmp3);
		return 1;
	}
	tmp5 = Pepona_estaCansada(tmp1);
	tmp4 = printf("%d\n", tmp5);
	return 1;
}
/* Pepita_Slang>>#Pepita_come: */
static Pepita_Slang *
Pepita_come(Pepita_Slang * self_in_Pepita_come, int arg1)
{
	(self_in_Pepita_come->energia) = ((self_in_Pepita_come->energia)) + arg1;
	return self_in_Pepita_come;
}
/* Pepita_Slang>>#Pepita_estaCansada */
static int
Pepita_estaCansada(Pepita_Slang * self_in_Pepita_estaCansada)
{
	return ((self_in_Pepita_estaCansada->energia)) < 10;
}
/* Pepita_Slang>>#Pepita_Slang_init */
static Pepita_Slang *
Pepita_Slang_init(Pepita_Slang * self_in_Pepita_Slang_init)
{
	(self_in_Pepita_Slang_init->energia) = 100;
	(self_in_Pepita_Slang_init->type) = 2;
	return self_in_Pepita_Slang_init;
}
/* Pepona_Slang>>#Pepona_come: */
static Pepona_Slang *
Pepona_come(Pepona_Slang * self_in_Pepona_come, int arg1)
{
	return self_in_Pepona_come;
}
/* Pepona_Slang>>#Pepona_estaCansada */
static int
Pepona_estaCansada(Pepona_Slang * self_in_Pepona_estaCansada)
{
	return ((self_in_Pepona_estaCansada->kms)) > 50;
}
/* Pepona_Slang>>#Pepona_Slang_init */
static Pepona_Slang *
Pepona_Slang_init(Pepona_Slang * self_in_Pepona_Slang_init)
{
	(self_in_Pepona_Slang_init->kms) = 0;
	(self_in_Pepona_Slang_init->type) = 5;
	return self_in_Pepona_Slang_init;
}
' copyReplaceAll: String cr with: String lf)
]
