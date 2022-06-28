Class {
	#name : #FamixCriticBrowserGenerator,
	#superclass : #FamixMetamodelGenerator,
	#instVars : [
		'violation',
		'rule',
		'context',
		'condition',
		'tRuleComponent'
	],
	#category : #'Famix-CriticBrowser-Generator'
}

{ #category : #accessing }
FamixCriticBrowserGenerator class >> packageName [

	^ #'Famix-CriticBrowser-Entities'
]

{ #category : #accessing }
FamixCriticBrowserGenerator class >> prefix [

	^ #'FamixCB'
]

{ #category : #accessing }
FamixCriticBrowserGenerator class >> submetamodels [
	^ { FamixGenerator }
]

{ #category : #definition }
FamixCriticBrowserGenerator >> defineClasses [
	super defineClasses.
	
	violation := builder newClassNamed: #Violation.
	rule := builder newClassNamed: #Rule.
	context := builder newClassNamed: #Context.
	condition := builder newClassNamed: #Condition
]

{ #category : #definition }
FamixCriticBrowserGenerator >> defineHierarchy [
	rule --|> #TNamedEntity.
	tRuleComponent --|> #TNamedEntity.
	context --|> tRuleComponent.
	condition --|> tRuleComponent
	
]

{ #category : #definition }
FamixCriticBrowserGenerator >> defineProperties [
	((rule property: #summary type: #String) 
		comment: 'A rule can have an explanatory summary').
	((tRuleComponent property: #summary type: #String) 
		comment: 'A rule component can have an explanatory summary').
	((context property: #entities type: #Object)
		comment: 'Entities matching the context').
	((context property: #contextBlock type: #Object)
		comment: 'Block to execute to get the context''s entities').
	((condition property: #query type: #Object)
		comment: 'Block to execute to find violations to the condition within the parent context').
]

{ #category : #definition }
FamixCriticBrowserGenerator >> defineRelations [
	super defineRelations.
	
	((violation property: #violatedRule)
			comment: 'Rule violated by this entity.')
		*-
	((rule property: #violations)
			comment: 'Every violation of this rule.').
			
	((violation property: #violatingEntity)
			comment: 'Entity raising this violation.')
		*-
	(((self remoteTrait: #TNamedEntity withPrefix: #Famix) property: #violations)
			comment: 'Every violation raised by this entity.').
			
	((context property: #children)
			comment: 'Every child context or condition of this context.')
		-*
	((tRuleComponent property: #parent)
			comment: 'Parent context, if it exists.')
]

{ #category : #definition }
FamixCriticBrowserGenerator >> defineTraits [

	super defineTraits.
	tRuleComponent := builder
		                  newTraitNamed: #TRuleComponent
		                  comment: 'I allow a rule component to be named and summarized.'.
]
