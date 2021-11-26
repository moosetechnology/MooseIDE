Extension { #name : #ColorTest }

{ #category : #'*MooseIDE-ColorPalette-Tests' }
ColorTest >> testHclToLab [

	self "white"
		assert: (Color new hclToLab: { 
					 #hue -> 0.
					 #chroma -> 0.
					 #luminance -> 100 } asDictionary)
		equals: { 
				#luminance -> 100.
				#a -> 0.
				#b -> 0 } asDictionary.

	self "black"
		assert: (Color new hclToLab: { 
					 #hue -> 0.
					 #chroma -> 0.
					 #luminance -> 0 } asDictionary)
		equals: { 
				#luminance -> 0.
				#a -> 0.
				#b -> 0 } asDictionary.

	self "red"
		assert: (Color new hclToLab: { 
					 #hue -> 40.85261277607024.
					 #chroma -> 106.83899941284552.
					 #luminance -> 54.29173376861782 } asDictionary)
		equals: { 
				#luminance -> 54.29173376861782.
				#a -> 80.81245531797708.
				#b -> 69.8850403235053 } asDictionary.

	self "green"
		assert: (Color new hclToLab: { 
					 #hue -> 134.39124580493436.
					 #chroma -> 113.33973051832487.
					 #luminance -> 87.81812823940444 } asDictionary)
		equals: { 
				#luminance -> 87.81812823940444.
				#a -> 79.28728092989569 negated.
				#b -> 80.99025618375522 } asDictionary.

	self "blue"
		assert: (Color new hclToLab: { 
					 #hue -> 301.368540512089.
					 #chroma -> 131.2070851917203.
					 #luminance -> 29.567572863553245 } asDictionary)
		equals: { 
				#luminance -> 29.567572863553245.
				#a -> 68.29865326565664.
				#b -> 112.02942991288029 negated } asDictionary
]

{ #category : #'*MooseIDE-ColorPalette-Tests' }
ColorTest >> testHclToRgb [

	self "white"
		assert: (Color new hclToRgb: { 
					 #hue -> 0.
					 #chroma -> 0.
					 #luminance -> 100 } asDictionary)
		equals: (Color r: 1 g: 1 b: 1).

	self "black"
		assert: (Color new hclToRgb: { 
					 #hue -> 0.
					 #chroma -> 0.
					 #luminance -> 0 } asDictionary)
		equals: (Color r: 0 g: 0 b: 0).

	self "red"
		assert: (Color new hclToRgb: { 
					 #hue -> 40.85261277607024.
					 #chroma -> 106.83899941284552.
					 #luminance -> 54.29173376861782 } asDictionary)
		equals: (Color r: 1 g: 0 b: 0).

	self "green"
		assert: (Color new hclToRgb: { 
					 #hue -> 134.39124580493436.
					 #chroma -> 113.33973051832487.
					 #luminance -> 87.81812823940444 } asDictionary)
		equals: (Color r: 0 g: 1 b: 0).

	self "blue"
		assert: (Color new hclToRgb: { 
					 #hue -> 301.368540512089.
					 #chroma -> 131.2070851917203.
					 #luminance -> 29.567572863553245 } asDictionary)
		equals: (Color r: 0 g: 0 b: 1)
]

{ #category : #'*MooseIDE-ColorPalette-Tests' }
ColorTest >> testLabToHcl [

	self "white"
		assert: (Color new labToHcl: { 
					 #luminance -> 100.
					 #a -> 0.
					 #b -> 0 } asDictionary)
		equals: { 
				#hue -> 0.
				#chroma -> 0.
				#luminance -> 100 } asDictionary. 

	self "black"
		assert: (Color new labToHcl: { 
					 #luminance -> 0.
					 #a -> 0.
					 #b -> 0 } asDictionary)
		equals: { 
				#hue -> 0.
				#chroma -> 0.
				#luminance -> 0 } asDictionary. 

	self "red"
		assert: (Color new labToHcl: { 
					 #luminance -> 54.29173376861782.
					 #a -> 80.8124553179771.
					 #b -> 69.8850403235053 } asDictionary)
		equals: { 
				#hue -> 40.85261277607024.
				#chroma -> 106.83899941284552.
				#luminance -> 54.29173376861782 } asDictionary. 

	self "green"
		assert: (Color new labToHcl: { 
					 #luminance -> 87.81812823940444.
					 #a -> 79.28728092989567 negated.
					 #b -> 80.99025618375524 } asDictionary)
		equals: { 
				#hue -> 134.39124580493436.
				#chroma -> 113.33973051832487.
				#luminance -> 87.81812823940444 } asDictionary. 

	self "blue"
		assert: (Color new labToHcl: { 
					 #luminance -> 29.567572863553245.
					 #a -> 68.29865326565671.
					 #b -> 112.02942991288025 negated } asDictionary)
		equals: { 
				#hue -> 301.368540512089.
				#chroma -> 131.2070851917203.
				#luminance -> 29.567572863553245 } asDictionary 
]

{ #category : #'*MooseIDE-ColorPalette-Tests' }
ColorTest >> testLabToRgb [

	self "white"
		assert: (Color new labToRgb: {
				#luminance -> 100.
				#a -> 0.
				#b -> 0 } asDictionary) 
		equals:  (Color r:1 g:1 b:1).

	self "black"
		assert: (Color new labToRgb: { 
					 #luminance -> 0.
					 #a -> 0.
					 #b -> 0 } asDictionary)
		equals: (Color r:0 g:0 b:0).

	self "red"
		assert: (Color new labToRgb: {
				#luminance -> 54.29173376861782. 
				#a -> 80.8124553179771. 
				#b -> 69.8850403235053} asDictionary)
		equals: (Color r:1 g:0 b:0).

	self "green"
		assert: (Color new labToRgb: {
				#luminance -> 87.81812823940444. 
				#a -> 79.28728092989567 negated. 
				#b -> 80.99025618375524} asDictionary)
		equals: (Color r:0 g:1 b:0).

	self "blue"
		assert: (Color new labToRgb: {
				#luminance -> 29.567572863553245. 
				#a -> 68.29865326565671. 
				#b -> 112.02942991288025 negated} asDictionary)
		equals: (Color r:0 g:0 b:1)
]

{ #category : #'*MooseIDE-ColorPalette-Tests' }
ColorTest >> testRgbToHcl [

	self "white"
		assert: (Color r: 1 g: 1 b: 1) rgbToHcl 
		equals: { 
			#hue -> 0.
			#chroma -> 0.
			#luminance -> 100 } asDictionary. 

	self "black"
		assert: (Color r: 0 g: 0 b: 0) rgbToHcl 
		equals: { 
			#hue -> 0.
			#chroma -> 0.
			#luminance -> 0 } asDictionary. 

	self "red"
		assert: (Color r: 1 g: 0 b: 0) rgbToHcl 
		equals: { 
			#hue -> 40.85261277607024.
			#chroma -> 106.83899941284552.
			#luminance -> 54.29173376861782 } asDictionary. 

	self "green"
		assert: (Color r: 0 g: 1 b: 0) rgbToHcl 
		equals: { 
			#hue -> 134.39124580493436.
			#chroma -> 113.33973051832487.
			#luminance -> 87.81812823940444 } asDictionary. 

	self "blue"
		assert: (Color r: 0 g: 0 b: 1) rgbToHcl 
		equals: { 
			#hue -> 301.368540512089.
			#chroma -> 131.2070851917203.
			#luminance -> 29.567572863553245 } asDictionary 
]

{ #category : #'*MooseIDE-ColorPalette-Tests' }
ColorTest >> testRgbToLab [

	self assert: (Color r: 1 g: 1 b: 1) rgbToLab equals: { 
			(#luminance -> 100).
			(#a -> 0).
			(#b -> 0) } asDictionary.

	self assert: (Color r: 0 g: 0 b: 0) rgbToLab equals: { 
			(#luminance -> 0).
			(#a -> 0).
			(#b -> 0) } asDictionary.

	self assert: (Color r: 1 g: 0 b: 0) rgbToLab equals: { 
			(#luminance -> 54.29173376861782).
			(#a -> 80.8124553179771).
			(#b -> 69.8850403235053) } asDictionary.

	self assert: (Color r: 0 g: 1 b: 0) rgbToLab equals: { 
			(#luminance -> 87.81812823940444).
			(#a -> 79.28728092989567 negated).
			(#b -> 80.99025618375524) } asDictionary.

	self assert: (Color r: 0 g: 0 b: 1) rgbToLab equals: { 
			(#luminance -> 29.567572863553245).
			(#a -> 68.29865326565671).
			(#b -> 112.02942991288025 negated) } asDictionary
]
