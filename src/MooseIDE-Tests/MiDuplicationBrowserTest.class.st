Class {
	#name : 'MiDuplicationBrowserTest',
	#superclass : 'MiAbstractBrowserTest',
	#category : 'MooseIDE-Tests-Browsers',
	#package : 'MooseIDE-Tests',
	#tag : 'Browsers'
}

{ #category : 'running' }
MiDuplicationBrowserTest >> browserClass [

	^ MiDuplicationBrowser
]

{ #category : 'running' }
MiDuplicationBrowserTest >> class: aName [

	^ FamixRepTestClass named: aName
]

{ #category : 'running' }
MiDuplicationBrowserTest >> class: aName withSource: lineInterval [

	^ (self class: aName)
		  sourceAnchor:
			  (FamixRepTestSourceTextAnchor source:
					   (self sourceCode: lineInterval));
		  yourself
]

{ #category : 'running' }
MiDuplicationBrowserTest >> defaultEntityToSelect [

	^ (self method: 'method1' withSource: (13 to: 14)) asMooseGroup
]

{ #category : 'running' }
MiDuplicationBrowserTest >> method: aName [

	^ FamixRepTestMethod named: aName
]

{ #category : 'running' }
MiDuplicationBrowserTest >> method: aName withSource: lineInterval [

	^ (self method: aName)
		  sourceAnchor:
			  (FamixRepTestSourceTextAnchor source:
					   (self sourceCode: lineInterval));
		  yourself
]

{ #category : 'tests - actions' }
MiDuplicationBrowserTest >> populateBrowser: mooseModel [

	mooseModel add: (FamixStClass new name: 'AClass').
	mooseModel add: (FamixStClass new name: 'AnotherClass').
	browser followEntity: mooseModel entities.

]

{ #category : 'running' }
MiDuplicationBrowserTest >> replicaFor: anEntity source: lineInterval [

	| replica |
	replica := (FamixReplica
		            from: lineInterval first
		            to: lineInterval last
		            for: anEntity)
		           fileAnchor:
			           (FamixRepTestSourceTextAnchor source:
					            anEntity sourceText);
		           yourself.

	anEntity addReplica: replica.
	^ replica
]

{ #category : 'running' }
MiDuplicationBrowserTest >> replicatedFragment [

	| fragment method replica |
	fragment := FamixReplicatedFragment new
		            fragmentName: 'testFragment';
		            yourself.

	method := self method: 'method1' withSource: (1 to: 40).
	replica := self replicaFor: method source: (13 to: 14).
	fragment addReplica: replica.

	method := self method: 'method2' withSource: (41 to: 48).
	replica := self replicaFor: method source: (43 to: 44).
	fragment addReplica: replica.

	^ fragment
]

{ #category : 'running' }
MiDuplicationBrowserTest >> sourceCode: lineInterval [
	"source code decomposed in lines to simplify selecting a lineInterval from it"

	| fullText |
	fullText := #(
'Once upon a time in the middle of a thick forest stood a small cottage,'
'the home of a pretty little girl known to everyone as Little Red Riding Hood.'
'One day, her Mummy waved her goodbye at the garden gate, saying: "Grandma is ill.'
'Take her this basket of cakes, but be very careful.'
'Keep to the path through the wood and don''t ever stop.'
'That way, you will come to no harm."'
'Little Red Riding Hood kissed her mother and ran off.'
'"Don''t worry," she said, "I''ll run all the way to Grandma''s without stopping."'
'Full of good intentions, the little girl made her way through the wood,'
'but she was soon to forget her mother''s wise words.'
'"What lovely strawberries! And so red."'
'Laying her basket on the ground, Little Red Riding Hood bent over the strawberry plants.'
'"They''re nice and ripe, and so big! Yummy! Delicious! Just another one.'
'And one more. This is the last. Well, this one Mmmm."'
'The red fruit peeped invitingly through the leaves in the grassy glade,'
'and Little Red Riding Hood ran back and forth popping strawberries into her mouth.'
'Suddenly she remembered her mother, her promise, Grandma and the basket and hurried back towards the path.'
'The basket was still in the grass and, humming to herself, Little Red Riding Hood walked on.'
'The wood became thicker and thicker.'
'Suddenly a yellow butterfly fluttered down through the trees.'
'Little Red Riding Hood started to chase the butterfly.'
'"I''ll catch you! I''ll catch you!" she called.'
'Suddenly she saw some large daisies in the grass.'
'"Oh, how sweet!" she exclaimed and, thinking of Grandma, she picked a large bunch of flowers.'
'In the meantime, two wicked eyes were spying on her from behind a tree a strange rustling in the woods made Little Red Riding Hood''s heart thump.'
'Now quite afraid she said to herself.'
'"I must find the path and run away from here!"'
'At last she reached the path again but her heart leapt into her mouth at the sound of a gruff voice which said: "Where are you going, my pretty girl, all alone in the woods?"'
'"I''m taking Grandma some cakes. She lives at the end of the path," said Little Riding Hood in a faint voice.'
'When he heard this, the wolf (for it was the big bad wolf himself) politely asked: "Does Grandma live by herself?"'
'"Oh, yes," replied Little Red Riding Hood, "and she never opens the door to strangers!"'
'"Goodbye. Perhaps we''ll meet again," replied the wolf. Then he loped away thinking to himself "I''ll gobble the grandmother first, then lie in wait for the grandchild!" At last, the cottage came in sight. Knock! Knock! The wolf rapped on the door.'
'"Who''s there?" cried Grandma from her bed.'
'"It''s me, Little Red Riding Hood. I''ve brought you some cakes because you''re ill," replied the wolf, trying hard to hide his gruff voice.'
'"Lift the latch and come in," said Grandma, unaware of anything amiss, till a horrible shadow appeared on the wall.'
'Poor Grandma! For in one bound, the wolf leapt across the room and, in a single mouthful, swallowed the old lady.'
'Soon after, Little Red Riding Hood tapped on the door.'
'"Grandma, can I come in?" she called.'
'Now, the wolf had put on the old lady''s shawl and cap and slipped into the bed.'
'Trying to imitate Grandma''s quavering little voice, he replied: "Open the latch and come in!'
'"What a deep voice you have," said the little girl in surprise.'
'"The better to greet you with," said the wolf.'
'"Goodness, what big eyes you have."'
'"The better to see you with."'
'"And what big hands you have!" exclaimed Little Red Riding Hood, stepping over to the bed.'
'"The better to hug you with," said the wolf.'
'"What a big mouth you have," the little girl murmured in a weak voice.'
'"The better to eat you with!" growled the wolf, and jumping out of bed, he swallowed her up too. Then, with a fat full tummy, he fell fast asleep.' ).

	^String cr join: (fullText copyFrom: lineInterval first to: lineInterval last)
]

{ #category : 'tests - actions' }
MiDuplicationBrowserTest >> testCanFollowEntity [

	| entities |
	entities := MooseGroup withAll: {
		(self class: 'AClass' withSource: (1 to: 8)) .
		(self method: 'aMethod' withSource: (1 to: 8)) }.

	self assert: (browser canFollowEntity: entities)

]

{ #category : 'tests - actions' }
MiDuplicationBrowserTest >> testCannotFollowEntityNoSourceAnchor [

	| entities |
	entities := MooseGroup withAll: {
		(self class: 'AClass') .
		(self method: 'aMethod' withSource: (1 to: 8)) }.

	self deny: (browser canFollowEntity: entities)

]

{ #category : 'tests - actions' }
MiDuplicationBrowserTest >> testFollowEntity [

	self assertEmpty: browser specModel entities.

	browser followEntity: {
			(self method: 'method1').
			(self method: 'method2') }.

	self assert: browser specModel entities size equals: 2.
	self assert: browser lstEntities items first name equals: 'method1'
]

{ #category : 'tests' }
MiDuplicationBrowserTest >> testMiSelectedItem [

	| entities |
	entities := {
		            (self method: 'method1').
		            (self method: 'method2') } asMooseGroup.

	browser specModel entities: entities.

	self denyEmpty: browser miSelectedItem.
	self assert: browser canPropagate.

	browser specModel selectEntities: entities.
	self assert: browser miSelectedItem size equals: 2.
	self assert: browser canPropagate
]

{ #category : 'tests' }
MiDuplicationBrowserTest >> testReplicaHasEntityNameInSourceCode [
	"Check that the entity name is on 1st line of its source code"

	| sourceCode |
	browser showReplicas: { self replicatedFragment replicas first }.

	sourceCode := browser panCodes pages first text.

	self assert: (sourceCode copyFrom: 1 to:7) equals: 'method1'
]

{ #category : 'tests' }
MiDuplicationBrowserTest >> testReplicaSourceCodeScrolledDown [
	"Check that the text is scrolled down:
	 - get textMorph, then ScrollPnae inside it
	 - get its vertical scrollbar
	 - it must not be on top (ie. value > 0)"

	| scroll |
	browser showReplicas: { self replicatedFragment replicas first }.

	scroll := browser panCodes pages first textMorph submorphs first vScrollbar value.

	self assert: (scroll > 0)
]

{ #category : 'tests' }
MiDuplicationBrowserTest >> testReplicatedFragmentDisplayString [

	self
		assert: self replicatedFragment displayString
		equals: '2x2:"They''re nice and ripe...'
]

{ #category : 'tests' }
MiDuplicationBrowserTest >> testSelectEntity [
	"issue https://github.com/moosetechnology/MooseIDE/issues/655"

	browser specModel entities: {
			(self method: 'method1').
			(self method: 'method2') } asMooseGroup.

	self shouldnt: (browser lstEntities selectIndex: 1) raise: Error
]

{ #category : 'tests - tags' }
MiDuplicationBrowserTest >> testSelectedTagSetAndGet [

	| model entity entity2 tag |
	model := FamixRepTestModel new.
	tag := model tagNamed: 'aTag'.
	entity := (self method: 'aMethod')
		          mooseModel: model;
		          yourself.
	entity2 := (self method: 'anotherMethod')
		           mooseModel: model;
		           yourself.

	browser followEntity: {
			entity.
			entity2 }.
	browser selectedTag: tag.
	self assert: browser selectedTag equals: tag
]

{ #category : 'tests - opening' }
MiDuplicationBrowserTest >> testSettingsAction [

	self assert: browser hasSettings
]

{ #category : 'tests' }
MiDuplicationBrowserTest >> testShowEntities [

	self assertEmpty: browser lstEntities items.

	browser stub.
	browser followEntity: {
			(self method: 'method1').
			(self method: 'method2') }.

	browser should receive showEntities
]

{ #category : 'tests' }
MiDuplicationBrowserTest >> testShowReplicas [

	self assertEmpty: browser panCodes pages.

	browser showReplicas: self replicatedFragment replicas.

	self assert: browser panCodes pages size equals: 2.
	self assert: browser panCodes pages first title equals: 'method1'
]

{ #category : 'tests' }
MiDuplicationBrowserTest >> testShowReplicatedFragments [

	| fragment |
	fragment := self replicatedFragment.
	browser specModel replicatedFragmentsHierarchy
		at: fragment
		put: #(  ).

	self assertEmpty: browser lstReplicatedFragments roots.
	browser showReplicatedFragments: { fragment }.

	self assert: browser lstReplicatedFragments roots size equals: 1.
	self
		assert: browser lstReplicatedFragments roots first
		equals: fragment
]

{ #category : 'tests' }
MiDuplicationBrowserTest >> testUpdateStatusBar [

	| fragment |
	self
		assert: browser statusBarText
		equals:
		'Searched entities: 0 | Number of clones: 0 | Entities with clones: 0 | Selected entities: 0 | Selected clones: 0'.

	browser followEntity: {
			(self method: 'method1').
			(self method: 'method2') }.
	self
		assert: browser statusBarText
		equals:
		'Searched entities: 2 | Number of clones: 0 | Entities with clones: 0 | Selected entities: 0 | Selected clones: 0'.
	fragment := self replicatedFragment.

	browser specModel replicatedFragmentsHierarchy
		at: fragment
		put: #(  ).
	browser updateStatusBar.
	self
		assert: browser statusBarText
		equals:
		'Searched entities: 2 | Number of clones: 1 | Entities with clones: 2 | Selected entities: 0 | Selected clones: 0'.

	browser specModel fragmentsSelection: { fragment }.
	self
		assert: browser updateStatusBar
		equals:
		'Searched entities: 2 | Number of clones: 1 | Entities with clones: 2 | Selected entities: 2 | Selected clones: 0'
]

{ #category : 'tests' }
MiDuplicationBrowserTest >> testresetDisplayedReplicas [

	browser showReplicas: self replicatedFragment replicas.
	self assert: browser panCodes pages size equals: 2.

	browser resetDisplayedReplicas.
	self assertEmpty: browser panCodes pages
]
