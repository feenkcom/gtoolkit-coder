Extension { #name : #GtCodersModel }

{ #category : #'*GToolkit-Coder-UI' }
GtCodersModel >> asCoderViewModel [
	^ self subclassResponsibility
]

{ #category : #'*GToolkit-Coder-UI' }
GtCodersModel >> asElement [
	^ self asCoderViewModel asElement
]
