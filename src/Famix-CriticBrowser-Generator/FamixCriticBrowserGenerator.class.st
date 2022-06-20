Class {
	#name : #FamixCriticBrowserGenerator,
	#superclass : #FamixMetamodelGenerator,
	#instVars : [
		'violation',
		'rule',
		'entity'
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
]

{ #category : #definition }
FamixCriticBrowserGenerator >> defineHierarchy [
	rule --|> #TNamedEntity.
	
]

{ #category : #definition }
FamixCriticBrowserGenerator >> defineProperties [
	((rule property: #summary type: #String) 
		comment: 'A rule can have an explanatory summary').
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
]
