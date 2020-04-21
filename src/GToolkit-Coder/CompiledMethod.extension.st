Extension { #name : #CompiledMethod }

{ #category : #'*GToolkit-Coder' }
CompiledMethod >> gtBrowseFrom: anElement [
	| aSpace |

	aSpace := BlSpace new
		title: 'Coder';
		extent: 1200 @ 600;
		addChild: (GtInspector withToolOn: (GtCoder forMethod: self));
		withHalos.

	anElement showSpace: aSpace.
]

{ #category : #'*GToolkit-Coder' }
CompiledMethod >> gtPackageScope [
	^ self package
]
