Class {
	#name : #OneTagGenerationStrategy,
	#superclass : #GenerationStrategy,
	#category : #'MooseIDE-Tagging-Generation'
}

{ #category : #public }
OneTagGenerationStrategy >> assignColor [

	^ Color green
]

{ #category : #'as yet unclassified' }
OneTagGenerationStrategy >> generateTags: anObject [

	| toTag tagName |
	tagClass = MiCriticTag
		ifTrue: [ 
			tagName := 'Violations'.
			toTag := self getEntitiesForConditions: anObject ]
		ifFalse: [ 
			tagName := 'Queried entities'.
			toTag := self getEntitiesForQuery: anObject ].

	^ { (Dictionary newFrom: { 
			   ('name' -> tagName).
			   ('color' -> self assignColor).
			   ('toTag' -> toTag asOrderedCollection).
			   ('category' -> category) }) }
]

{ #category : #'as yet unclassified' }
OneTagGenerationStrategy >> getEntitiesForConditions: anObject [

	| toTag |
	toTag := Set new.
	anObject do: [ :cond | 
		cond runUpTree: entities.
		toTag addAll: cond violations asMooseGroup specialize allEntities ].

	^ toTag
]

{ #category : #'as yet unclassified' }
OneTagGenerationStrategy >> getEntitiesForQuery: anObject [

	| queriedEntities |
	queriedEntities := Set new.
	anObject do: [ :query | 
		| runnableQuery |
		runnableQuery := MiCriticBrowserFQQuery on: query.
		queriedEntities addAll: (runnableQuery runOnCollection: entities) ].

	^ queriedEntities
]
