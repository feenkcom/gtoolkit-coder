Extension { #name : #Behavior }

{ #category : #'*GToolkit-Coder-Extensions' }
Behavior >> gtBrowse [
	^ (GtCoder forClass: self) openInPager maximized
]

{ #category : #'*GToolkit-Coder-Extensions' }
Behavior >> gtBrowseFrom: anElement [
	^ ((GtCoder forClass: self) asElement openInPagerFrom: anElement) maximized
]

{ #category : #'*GToolkit-Coder-Extensions' }
Behavior >> methodsCoderFromContext: aPhlowContext [
	<return: #GtPharoMethodsCoderViewModel>

	^ (GtClassMethodsCoder forClass: self) asCoderViewModel
]
