Class {
	#name : #MooseAbstractMenuCommandTest,
	#superclass : #TestCase,
	#category : #'MooseIDE-Tests-Menubar'
}

{ #category : #tests }
MooseAbstractMenuCommandTest >> testMenuCommandOn [

	| builder |
	builder := PragmaMenuBuilder new.
	self assert: builder itemList isNil.

	MooseAbstractMenuCommand menuCommandOn: builder.

	self assert: builder itemList isCollection.
	self denyEmpty: builder itemList
]
