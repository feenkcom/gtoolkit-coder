Extension { #name : #Behavior }

{ #category : #'*GToolkit-Coder-Extensions' }
Behavior >> gtBrowse [
	^ (GtCoderElement forClass: self) openInPager maximized
]

{ #category : #'*GToolkit-Coder-Extensions' }
Behavior >> gtBrowseFrom: anElement [
	^ ((GtCoderElement forClass: self) asElement openInPagerFrom: anElement) maximized
]

{ #category : #'*GToolkit-Coder-Extensions' }
Behavior >> methodsCoderFromContext: aPhlowContext [
	<return: #GtPharoMethodsCoderViewModel>

	^ (GtClassMethodsCoder forClass: self) asCoderViewModel
]
