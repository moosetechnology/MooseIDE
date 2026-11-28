"
I check that every MooseIDE browser inherits from MiAbstractBrowser (MiAbstractBrowser itself excepted).

Collaborators: MiAbstractBrowser; definitions inherited from MiAbstractArchitecturalRule.
Main API: #basicCheck: answers true for a browser outside the MiAbstractBrowser hierarchy.
"
Class {
	#name : 'MiBrowserInheritanceRule',
	#superclass : 'MiAbstractArchitecturalRule',
	#category : 'MooseIDE-ArchitecturalRules',
	#package : 'MooseIDE-ArchitecturalRules'
}

{ #category : 'accessing' }
MiBrowserInheritanceRule class >> rationale [
	^ 'All MooseIDE browsers (classes named Mi*Browser in a MooseIDE-* package) must inherit from MiAbstractBrowser, which provides the bus connection, the model link and #followEntity:.'
]

{ #category : 'accessing' }
MiBrowserInheritanceRule class >> ruleName [
	^ 'MooseIDE browser does not inherit from MiAbstractBrowser'
]

{ #category : 'manifest' }
MiBrowserInheritanceRule class >> uniqueIdentifierName [
	^ 'MiBrowserInheritanceRule'
]

{ #category : 'running' }
MiBrowserInheritanceRule >> basicCheck: aClass [
	^ (self isBrowser: aClass) and: [
		  aClass ~~ MiAbstractBrowser and: [ (aClass inheritsFrom: MiAbstractBrowser) not ] ]
]
