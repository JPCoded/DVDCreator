package Mvid::BName;

use warnings;
use strict;
use File::Basename;
use File::Slurp qw(slurp);
use File::Slurp;


=head1 NAME

Mvid::BName - The great new Mvid::BName!

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';


=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use Mvid::BName;

    my $foo = Mvid::BName->new();
    ...

=head1 EXPORT

A list of functions that can be exported.  You can delete this section
if you don't export anything, such as for a purely object-oriented module.

=head1 FUNCTIONS

=head2 name

=cut

sub name {
	my($self) = shift;
	return $self->{NAME};
}

=head2 dir

=cut

sub dir {
	my($self) = shift;
	return $self->{DIR};
}

=head2 suffix

=cut

sub suffix {
	my($self) = shift;
	return $self->{SUFFIX};
}

=head2 new

=cut

sub new {
  my($class) = shift;
  my($self) = {NAME => "Foo",
			   DIR => "/media/RAID/",
			   SUFFIX => ".mkv"};
  bless $self,$class;
  return $self;
}

=head2 set

=cut

sub set {
	my($self)=shift;	
	my($file)=shift;
	my(@suffixlist) = qw(.mkv .ogg .avi .mp4 .ogm .mpg);
	my ($name,$dir,$suffix) = fileparse($file,@suffixlist);
	$self->{NAME} = $name;
	$self->{DIR} = $dir;
	$self->{SUFFIX} = $suffix;	
}

=head1 AUTHOR

John, C<< <byteme> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-mvid-bname at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Mvid-BName>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Mvid::BName


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Mvid-BName>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Mvid-BName>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Mvid-BName>

=item * Search CPAN

L<http://search.cpan.org/dist/Mvid-BName>

=back


=head1 ACKNOWLEDGEMENTS


=head1 COPYRIGHT & LICENSE

Copyright 2010 John, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.


=cut

1; # End of Mvid::BName
