"
I check that every concrete MooseIDE model implements #entities (the entities displayed by its browser) and #miSelectedItem (the entities selected in it), which MiAbstractModel declares as subclassResponsibility.

Collaborators: MiAbstractModel; definitions inherited from MiAbstractArchitecturalRule.
Invariants: abstract models and models with subclasses are exempt; only models inside the MiAbstractModel hierarchy are checked (the others are reported by MiModelInheritanceRule).
Main API: #basicCheck:, #missingSelectorsIn: (named in the critique hint).
"
Class {
	#name : 'MiModelKeepsEntitiesRule',
	#superclass : 'MiAbstractArchitecturalRule',
	#category : 'MooseIDE-ArchitecturalRules',
	#package : 'MooseIDE-ArchitecturalRules'
}

{ #category : 'accessing' }
MiModelKeepsEntitiesRule class >> rationale [
	^ 'A concrete MooseIDE model must answer the entities displayed by its browser (#entities) and the entities selected in it (#miSelectedItem). MiAbstractModel declares both as subclassResponsibility.'
]

{ #category : 'accessing' }
MiModelKeepsEntitiesRule class >> ruleName [
	^ 'MooseIDE model does not keep its displayed or selected entities'
]

{ #category : 'manifest' }
MiModelKeepsEntitiesRule class >> uniqueIdentifierName [
	^ 'MiModelKeepsEntitiesRule'
]

{ #category : 'running' }
MiModelKeepsEntitiesRule >> basicCheck: aClass [
	^ (self isModel: aClass) and: [
		  aClass isAbstract not and: [
			  aClass subclasses isEmpty and: [
				  (aClass inheritsFrom: MiAbstractModel) and: [
					  (self missingSelectorsIn: aClass) isNotEmpty ] ] ] ]
]

{ #category : 'helpers' }
MiModelKeepsEntitiesRule >> critiqueFor: aClass [
	^ (super critiqueFor: aClass)
		  tinyHint: 'missing: ' , ((self missingSelectorsIn: aClass) joinUsing: ', ');
		  yourself
]

{ #category : 'accessing' }
MiModelKeepsEntitiesRule >> missingSelectorsIn: aClass [
	"The required selectors that aClass still inherits as subclassResponsibility from MiAbstractModel"

	^ self requiredSelectors select: [ :selector |
		  (aClass lookupSelector: selector) methodClass == MiAbstractModel ]
]

{ #category : 'accessing' }
MiModelKeepsEntitiesRule >> requiredSelectors [
	^ #( #entities #miSelectedItem )
]
