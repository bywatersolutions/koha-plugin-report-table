package Koha::Plugin::Com::ByWaterSolutions::ReportTable;

use Modern::Perl;

use base qw(Koha::Plugins::Base);

use C4::Context;
use C4::Reports::Guided;

## Here we set our plugin version
our $VERSION = 1.00;

## Here is our metadata, some keys are required, some are optional
our $metadata = {
    name   => 'ReportTable',
    author => 'Kyle M Hall',
    description => 'This plugin contains a script that will generate an html table from a report to be used on public displays',
    date_authored   => '2017-06-13',
    date_updated    => '2017-06-13',
    minimum_version => '16.06.00.000',
    maximum_version => undef,
    version         => $VERSION,
};

sub new {
    my ( $class, $args ) = @_;

    $args->{'metadata'} = $metadata;
    $args->{'metadata'}->{'class'} = $class;

    my $self = $class->SUPER::new($args);

    return $self;
}

sub report {
    my ( $self, $args ) = @_;
    my $cgi = $self->{'cgi'};

    my $dbh = C4::Context->dbh;
    my $report_id = $cgi->param('report_id');
    my $report = get_saved_report($report_id);
    warn Data::Dumper::Dumper( $report );
    my ( $sth, $errors ) = execute_query( $report->{savedsql}, my $offset, my $limit, undef, $report_id );
    my $results = $dbh->selectall_arrayref( $sth, { Slice => {} } );
    warn Data::Dumper::Dumper( $results );

    my $template = $self->get_template( { file => 'report_table.tt' } );
    $template->param( $cgi->Vars );
    $template->param(
        errors  => $errors,
        results => $results,
    );

    print $cgi->header();
    print $template->output();
}

sub tool {
    my ( $self, $args ) = @_;
    my $cgi = $self->{'cgi'};

    my $template = $self->get_template( { file => 'nothing.tt' } );
    print $cgi->header();
    print $template->output();
}

sub install() {
    my ( $self, $args ) = @_;

    return 1;
}

sub uninstall() {
    my ( $self, $args ) = @_;

    return 1;
}

1;
