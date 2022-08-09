Class {
	#name : #GradualTagsGenerationStrategy,
	#superclass : #GenerationStrategy,
	#instVars : [
		'colors'
	],
	#category : #'MooseIDE-Tagging-Generation'
}

{ #category : #'as yet unclassified' }
GradualTagsGenerationStrategy class >> bounds [

	^ { 1. 2. 3. 5. 10. }
]

{ #category : #accessing }
GradualTagsGenerationStrategy class >> colorPalette [

	^ RSColorPalette sequential ylorrd9
]

{ #category : #'as yet unclassified' }
GradualTagsGenerationStrategy class >> rangeForCriticsGeneration [

	^ Dictionary newFrom: { 
			  ('Nb of violations = 1' -> { 1 }).
			  ('Nb of violations = 2' -> { 2 }).
			  ('Nb of violations = 3' -> { 3 }).
			  ('3 > Nb of violations <= 5 ' -> { 4. 5 }).
			  ('5 > Nb of violations <= 10' -> { 6. 10 }) }
]

{ #category : #public }
GradualTagsGenerationStrategy >> assignColor [

	colors ifEmpty: [ 
		colors := self class colorPalette range asOrderedCollection ].
	^ colors removeFirst
]

{ #category : #'as yet unclassified' }
GradualTagsGenerationStrategy >> dictForStaticTagWithName: aString color: aColor entities: aCollection [

	^ Dictionary newFrom: { 
			  ('name' -> aString).
			  ('color' -> aColor).
			  ('category' -> category).
			  ('toTag' -> aCollection) }
]

{ #category : #'as yet unclassified' }
GradualTagsGenerationStrategy >> generateBagForCriticTags: anObject [

	| bagOfEntities |
	bagOfEntities := Bag new.
	anObject do: [ :cond | 
		cond runUpTree: entities.
		cond violations ifNotEmpty: [ 
			bagOfEntities addAll:
				cond violations asMooseGroup specialize allEntities ] ].
	anObject do: [ :condition | condition removeAllViolations ].
	
	^ bagOfEntities
]

{ #category : #'as yet unclassified' }
GradualTagsGenerationStrategy >> generateBagForQueryTags: anObject [

	| bagOfEntities |
	bagOfEntities := Bag new.
	anObject do: [ :query | 
		| runnableQuery |
		runnableQuery := MiCriticBrowserFQQuery on: query.
		bagOfEntities addAll: (runnableQuery runOnCollection: entities) ].

	^ bagOfEntities
]

{ #category : #'as yet unclassified' }
GradualTagsGenerationStrategy >> generateTags: anObject [

	| bagOfEntities namePattern tags toTag |
	"gets entities to tag"
	tagClass = MiCriticTag
		ifTrue: [ 
			bagOfEntities := self generateBagForCriticTags: anObject.
			namePattern := 'Nb of violations ' ]
		ifFalse: [ 
			bagOfEntities := self generateBagForQueryTags: anObject.
			namePattern := 'Nb of times queried ' ].

	tags := OrderedCollection new.
	self class bounds do: [ :bound | 
		toTag := OrderedCollection new.
		bagOfEntities doWithOccurrences: [ :entity :value | 
			value <= bound ifTrue: [ toTag add: entity ] ].

		toTag ifNotEmpty: [ 
			tags add: (self
					 dictForStaticTagWithName: namePattern , '<= ' , bound asString
					 color: self assignColor
					 entities: toTag) ] ].

	toTag := OrderedCollection new.
	bagOfEntities doWithOccurrences: [ :entity :value | 
		value > self class bounds last ifTrue: [ toTag add: entity ] ].
	
	tags add: (self
			 dictForStaticTagWithName:
			 namePattern , '> ' , self class bounds last asString
			 color: self assignColor
			 entities: toTag).

	^ tags
]

{ #category : #initialization }
GradualTagsGenerationStrategy >> initialize [ 

	super initialize.
	colors := self class colorPalette range asOrderedCollection
]
