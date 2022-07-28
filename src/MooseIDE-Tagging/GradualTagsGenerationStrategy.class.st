Class {
	#name : #GradualTagsGenerationStrategy,
	#superclass : #GenerationStrategy,
	#instVars : [
		'colors'
	],
	#category : #'MooseIDE-Tagging-Generation'
}

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
GradualTagsGenerationStrategy >> createQueryTagFor: anEvaluatingObject [

	^ MiQueryTag new
		  name: anEvaluatingObject name;
		  evaluatingObject: anEvaluatingObject;
		  color: self assignColor
]

{ #category : #'as yet unclassified' }
GradualTagsGenerationStrategy >> dictForStaticTagWithName: aString color: aColor entities: aCollection [
	^ Dictionary newFrom: { 'name' -> aString. 'color' -> aColor. 'category' -> category. 'toTag' -> aCollection }
]

{ #category : #'as yet unclassified' }
GradualTagsGenerationStrategy >> generateCriticTags: anObject [

	| bagOfViolatingEntities range tags |
	"fetch all violations"
	bagOfViolatingEntities := Bag new.
	anObject do: [ :cond | 
		cond runUpTree: entities.
		cond violations ifNotEmpty: [ 
			bagOfViolatingEntities addAll:
				cond violations asMooseGroup specialize allEntities ] ].

	range := self class rangeForCriticsGeneration.
	tags := OrderedCollection new.

	"find entities to tag according to number of violations"
	range keys do: [ :key | 
		| fst snd toTag |
		toTag := OrderedCollection new.
		fst := (range at: key) first.
		(range at: key) size = 1
			ifTrue: [ 
				bagOfViolatingEntities doWithOccurrences: [ :entity :value | 
					value = fst ifTrue: [ toTag add: entity ] ] ]
			ifFalse: [ 
				snd := (range at: key) last.
				bagOfViolatingEntities doWithOccurrences: [ :entity :value | 
					(value > fst and: [ value <= snd ]) ifTrue: [ toTag add: entity ] ] ].

		"creates the tag if there are entities to tag"
		toTag ifNotEmpty: [ 
			tags add: (self
					 dictForStaticTagWithName: key
					 color: self assignColor
					 entities: toTag) ] ].

	anObject do: [ :condition | condition removeAllViolations ].
	^ tags
]

{ #category : #'as yet unclassified' }
GradualTagsGenerationStrategy >> generateQueryTags: anObject [
	
	^ anObject collect: [ :query | self createQueryTagFor: query ]
]

{ #category : #'as yet unclassified' }
GradualTagsGenerationStrategy >> generateTags: anObject [

	^ tagClass = MiQueryTag
		ifTrue: [ self generateQueryTags: anObject ]
		ifFalse: [ self generateCriticTags: anObject ]
]

{ #category : #initialization }
GradualTagsGenerationStrategy >> initialize [ 

	super initialize.
	colors := self class colorPalette range asOrderedCollection
]
