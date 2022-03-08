"
Mock class used by this packages for testing
"
Class {
	#name : #MiCoTestClass,
	#superclass : #Object,
	#instVars : [
		'var1',
		'var2',
		'var3',
		'var4',
		'var5',
		'var6'
	],
	#category : #'MooseIDE-CoUsageMap-Tests'
}

{ #category : #accessing }
MiCoTestClass >> method1 [

	var1 := var2 := 3.1416.
	var1 := var1 * 2
]

{ #category : #accessing }
MiCoTestClass >> method2 [

	| tmp1 |
	tmp1 := 3.1416
]

{ #category : #accessing }
MiCoTestClass >> method3 [

	var4 ifNil: [ var2 := var3 := 3.1416 ]
]

{ #category : #accessing }
MiCoTestClass >> method4 [

	var6 := var6 + 1
]

{ #category : #accessing }
MiCoTestClass >> method5 [

	var6 := 3.1416
]
