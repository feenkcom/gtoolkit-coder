Extension { #name : #GtSearchFilter }

{ #category : #'*GToolkit-Coder' }
GtSearchFilter >> asCoder [
	^ self result asCoder
]

{ #category : #'*GToolkit-Coder' }
GtSearchFilter >> gtExamples [
	| examples |
	examples := OrderedCollection new.
	self result do: [ :each | examples addAll: each gtExamples ].
	^ GtExampleGroup withAll: examples
]

{ #category : #'*GToolkit-Coder' }
GtSearchFilter >> highlighter [
	^ nil
]
