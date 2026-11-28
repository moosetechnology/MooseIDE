"
I check that every concrete MooseIDE browser MiXyzBrowser has a model class named MiXyzModel.

Collaborators: the class environment, where the model class is looked up by name; definitions inherited from MiAbstractArchitecturalRule.
Invariants: abstract browsers (class-side #isAbstract answers true, e.g. MiAbstractBrowser, MiAbstractVisualizationBrowser) are exempt.
Main API: #basicCheck: answers true for a concrete browser without a model class.
"
Class {
	#name : 'MiBrowserHasModelRule',
	#superclass : 'MiAbstractArchitecturalRule',
	#category : 'MooseIDE-ArchitecturalRules',
	#package : 'MooseIDE-ArchitecturalRules'
}

{ #category : 'accessing' }
MiBrowserHasModelRule class >> rationale [
	^ 'Every concrete MooseIDE browser MiXyzBrowser must have a model class named MiXyzModel that keeps the displayed and selected entities. Abstract browsers (class-side #isAbstract) are exempt.'
]

{ #category : 'accessing' }
MiBrowserHasModelRule class >> ruleName [
	^ 'MooseIDE browser has no model class'
]

{ #category : 'manifest' }
MiBrowserHasModelRule class >> uniqueIdentifierName [
	^ 'MiBrowserHasModelRule'
]

{ #category : 'running' }
MiBrowserHasModelRule >> basicCheck: aClass [
	^ (self isBrowser: aClass) and: [
		  aClass isAbstract not and: [
			  (self class environment includesKey: (self modelNameFor: aClass)) not ] ]
]
