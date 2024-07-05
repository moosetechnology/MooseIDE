Class {
	#name : #FamixCriticBrowserGenerator,
	#superclass : #FamixMetamodelGenerator,
	#instVars : [
		'violation',
		'context',
		'condition',
		'tRuleComponent',
		'rootContext',
		'mooseObject'
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
	^ { FamixGenerator . MooseModelGenerator }
]

{ #category : #definition }
FamixCriticBrowserGenerator >> defineClasses [

	super defineClasses.

	violation := builder newClassNamed: #Violation.
	rootContext := builder newClassNamed: #RootContext.
	context := builder newClassNamed: #Context.
	condition := builder newClassNamed: #Condition.

	mooseObject := self remoteEntity: #Object withPrefix: #Moose
]

{ #category : #definition }
FamixCriticBrowserGenerator >> defineHierarchy [

	tRuleComponent --|> #TNamedEntity.
	context --|> tRuleComponent.
	rootContext --|> context.
	condition --|> tRuleComponent
]

{ #category : #definition }
FamixCriticBrowserGenerator >> defineProperties [

	(tRuleComponent property: #summary type: #String) comment:
		'A rule component can have an explanatory summary'.
	(context property: #contextBlock type: #Object) comment:
		'Block to execute to get the context''s entities'.
	(condition property: #query type: #Object) comment:
		'Block to execute to find violations to the condition within the parent context'.
	(condition property: #severity type: #Object) comment:
		'Severity for the violations of this condition'
]

{ #category : #definition }
FamixCriticBrowserGenerator >> defineRelations [
	super defineRelations.
			
	((violation property: #violatedCondition)
			comment: 'Condition violated by this entity.')
		*-
	((condition property: #violations)
			comment: 'Every violation of this condition.').
			
	((violation property: #violatingEntity)
			comment: 'Entity raising this violation.')
		*-
	((mooseObject property: #violations)
			comment: 'Every violation raised by this entity.').
			
	((context property: #children)
			comment: 'Every child context or condition of this context.')
		-*
	((tRuleComponent property: #parent)
			comment: 'Parent context, if it exists.').
			
	((context property: #entities)
			comment: 'Every entity that is a part of the context.')
		*-*
	((mooseObject property: #contexts)
			comment: 'Every context that the entity is a part of.')
]

{ #category : #definition }
FamixCriticBrowserGenerator >> defineTraits [

	super defineTraits.
	tRuleComponent := builder
		                  newTraitNamed: #TRuleComponent
		                  comment: 'I allow a rule component to be named and summarized.'.
]
