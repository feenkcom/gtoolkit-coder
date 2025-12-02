Extension { #name : #GtPhlowAction }

{ #category : #'*GToolkit-Coder-UI' }
GtPhlowAction >> asNavigationElement: aBlock withHostElement: aTargetElement [
	<return: #BlElement>
	^ self
		asElement: [ :anElement | 
			anElement states addState: BrSizeAdjustmentState mini.
			aBlock value: anElement ]
		withHostElement: aTargetElement
]
