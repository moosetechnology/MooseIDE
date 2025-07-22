"
A MiExportModelTest is a test class for testing the behavior of MiExportModel
"
Class {
	#name : 'MiExportModelTest',
	#superclass : 'TestCase',
	#instVars : [
		'model'
	],
	#category : 'MooseIDE-Tests-Browsers',
	#package : 'MooseIDE-Tests',
	#tag : 'Browsers'
}

{ #category : 'running' }
MiExportModelTest >> setUp [
	super setUp.

	model := MiExportModel new.
]

{ #category : 'running' }
MiExportModelTest >> testaddColumnForQuerywithNameReturnAColumn [

	| returned |
	returned := model addColumnForQuery: [ :param |  ] withName: #aName.
	self assert: returned class equals: MiExportQueryColumnModel
]
