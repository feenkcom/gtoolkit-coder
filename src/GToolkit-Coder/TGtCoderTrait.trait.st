Trait {
	#name : #TGtCoderTrait,
	#category : #'GToolkit-Coder-Coders'
}

{ #category : #converting }
TGtCoderTrait >> asMainCoder [
	^ GtCoder forCoder: self
]

{ #category : #testing }
TGtCoderTrait >> isForClass [
	^ false
]

{ #category : #testing }
TGtCoderTrait >> isForPackage [
	^ false
]

{ #category : #testing }
TGtCoderTrait >> isForPackageTag [
	^ false
]

{ #category : #accessing }
TGtCoderTrait >> package [
	^ nil
]

{ #category : #accessing }
TGtCoderTrait >> packageTag [
	^ nil
]

{ #category : #accessing }
TGtCoderTrait >> theClass [
	^ nil
]
