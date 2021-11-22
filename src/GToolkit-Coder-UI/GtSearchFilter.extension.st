Extension { #name : #GtSearchFilter }

{ #category : #'*GToolkit-Coder-UI' }
GtSearchFilter >> asCoder [
	^ self result asCoder
]

{ #category : #'*GToolkit-Coder-UI' }
GtSearchFilter >> asElement [
	^ self asCoder asElement
]

{ #category : #'*GToolkit-Coder-UI' }
GtSearchFilter >> gtExamples [
	| examples |
	examples := OrderedCollection new.
	self result do: [ :each | examples addAll: each gtExamples ].
	^ GtExampleGroup withAll: examples
]

{ #category : #'*GToolkit-Coder-UI' }
GtSearchFilter >> highlighter [
	^ nil
]
